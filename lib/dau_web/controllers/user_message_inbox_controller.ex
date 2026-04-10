defmodule DAUWeb.IncomingMessageController do
  use DAUWeb, :controller

  # alias DAU.Vendor.Slack.Message
  require Logger
  alias DAU.UserMessage.Analytics
  alias DAU.UserMessage.Analytics.Event
  alias DAU.MediaMatch
  alias DAU.MediaMatch.HashWorkerRequest
  alias DAU.MediaMatch.HashWorkerGenServer
  alias DAU.Vendor.Gupshup.DeliveryReport
  alias DAU.UserMessage
  alias DAU.UserMessage.Inbox
  alias FileManager
  alias DAU.Feed

  action_fallback DAUWeb.FallbackController

  def index(conn, _params) do
    incoming_messages = UserMessage.list_incoming_messages()
    render(conn, :index, incoming_messages: incoming_messages)
  end

  def create(conn, payload) do
    with {:ok, _} <- authenticate_request(conn) do
      alias UserMessage.Conversation
      alias MediaMatch.Blake2B

      case Conversation.add_to_inbox(payload) do
        {:ok, inbox} ->
          conn = conn |> Plug.Conn.send_resp(200, [])

          Task.start(fn ->
            with {:ok, properties_added} <- Conversation.add_message_properties(inbox),
                 :ok <-
                   if(inbox.media_type in ["audio", "video"],
                     do: Blake2B.create_job(properties_added),
                     else: :ok
                   ) do
            else
              error ->
                Logger.error("Error in processing message in background #{inspect(error)}")
                Sentry.capture_message("Could not process message. #{inspect(error)}")
            end
          end)

          conn

        {:error, _reason} ->
          conn |> send_400()
      end
    else
      {:error, :unauthorized} ->
        conn |> send_401()
    end
  rescue
    error ->
      Logger.error("Error in controller for POST /gupshup/message. #{inspect(error)}")
      Sentry.capture_exception(error, stacktrace: __STACKTRACE__)
      Sentry.capture_message("Could not add message. #{inspect(payload)}")
      conn |> send_400()
  end

  def show(conn, %{"id" => id}) do
    incoming_message = UserMessage.get_incoming_message!(id)
    render(conn, :show, incoming_message: incoming_message)
  end

  def receive_delivery_report(conn, params) do
    case verify_turn_webhook_signature(conn) do
      :ok ->
        process_delivery_report(conn, params)

      :error ->
        Logger.warning("TURN delivery report webhook signature verification failed")
        conn |> send_401()
    end
  end

  def send_400(conn) do
    conn
    |> put_resp_content_type("application/json")
    |> resp(400, Jason.encode!(%{status: :invalid_request}))
    |> send_resp()
  end

  def send_401(conn) do
    conn
    |> put_resp_content_type("application/json")
    |> resp(401, Jason.encode!(%{status: :unauthorized}))
    |> send_resp()
  end

  # Function to authenticate Turn Tipline API
  # that Turn calls to send media items to dashboard
  defp authenticate_request(conn) do
    raw_token = get_req_header(conn, "authorization") |> List.first()
    stored_token = System.get_env("TURN_TIPLINE_WEBHOOK_SECRET")

    token =
      case raw_token do
        "Bearer " <> token -> token
        _ -> nil
      end

    case {token, stored_token} do
      {nil, _} ->
        Logger.warning(
          "TURN WEBHOOK authentication failed: No authorization header provided or invalid format"
        )

        {:error, :unauthorized}

      {_, nil} ->
        Logger.error(
          "TURN WEBHOOK authentication failed: TURN_TIPLINE_WEBHOOK_SECRET not configured"
        )

        {:error, :unauthorized}

      {provided_token, expected_token} ->
        if Plug.Crypto.secure_compare(provided_token, expected_token) do
          {:ok, :authenticated}
        else
          Logger.warning("TURN WEBHOOK authentication failed: Invalid token provided")
          {:error, :unauthorized}
        end
    end
  end

  @doc """
  Verifies the TURN delivery report webhook signature to ensure the request came from TURN.

  TURN webhooks include an X-Turn-Hook-Signature header.
  verify by:
  1. Extracting the signature header and raw body from conn
  2. Computing an HMAC-SHA256 using the webhook secret
  3. Base64 encoding the result
  4. Using constant-time comparison to prevent timing attacks
  """
  defp verify_turn_webhook_signature(conn) do
    secret = System.get_env("TURN_DELIVERY_REPORT_WEBHOOK_SECRET")
    signature = get_req_header(conn, "x-turn-hook-signature") |> List.first()
    raw_body = conn.assigns[:raw_body] || ""

    if is_nil(signature) or signature == "" do
      Logger.warning(
        "TURN webhook signature verification failed: Missing x-turn-hook-signature header"
      )

      :error
    else
      case secret do
        nil ->
          Logger.error(
            "TURN webhook signature verification failed: TURN_DELIVERY_REPORT_WEBHOOK_SECRET not configured"
          )

          :error

        secret ->
          expected =
            :crypto.mac(:hmac, :sha256, secret, raw_body)
            |> Base.encode64()

          # constant-time comparison to prevent timing attacks
          if Plug.Crypto.secure_compare(signature, expected) do
            :ok
          else
            Logger.warning("TURN webhook signature verification failed: Invalid signature")
            :error
          end
      end
    end
  end

  defp process_delivery_report(conn, params) do
    bsp = Application.fetch_env!(:dau, :bsp)

    try do
      # {msg_id, delivery_params} = DeliveryReport.make_delivery_report_for_outbox(params) # Used before Turn Bsp

      {msg_id, delivery_params} = bsp.make_delivery_report_for_outbox(params)

      case UserMessage.add_delivery_report_by_eid(msg_id, delivery_params) do
        {:ok, _} ->
          Logger.info("report added to db")

        {:error, reason} ->
          Logger.error("Failed to add delivery report: #{reason}")
      end

      Task.async(fn -> Analytics.create_delivery_event(params) end)

      conn
      |> put_resp_content_type("application/json")
      |> resp(200, Jason.encode!(%{status: :ok}))
      |> send_resp()
    rescue
      error ->
        Logger.error("Error processing delivery report: #{inspect(error)}")
        Sentry.capture_exception(error, stacktrace: __STACKTRACE__)

        conn
        |> put_resp_content_type("application/json")
        |> resp(200, Jason.encode!(%{status: :ok}))
        |> send_resp()

        # Message.send(:dau_alerts, "invalid_delivery_report", "Invalid delivery report", params)
    end
  end
end
