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
    alias UserMessage.Conversation
    alias MediaMatch.Blake2B

    case Conversation.add_to_inbox(payload) do
      {:ok, inbox} ->
        conn |> Plug.Conn.send_resp(200, [])

        Task.start(fn ->
          if inbox.media_type in ["audio", "video"] do
            with {:ok, properites_added} <- Conversation.add_message_properties(inbox),
                 {:ok, job_added} <- Blake2B.create_job(properites_added) do
            end
          end
        end)

      {:error, reason} ->
        conn |> send_400()
    end
  rescue
    error ->
      Logger.error("Error in controller for  POST /gupshup/message. #{inspect(error)}")
      Sentry.capture_exception(error, stacktrace: __STACKTRACE__)
      Sentry.capture_message("Could not add message. #{inspect(payload)}")
      conn |> send_400()
  end

  def show(conn, %{"id" => id}) do
    incoming_message = UserMessage.get_incoming_message!(id)
    render(conn, :show, incoming_message: incoming_message)
  end

  def receive_delivery_report(conn, params) do
    bsp = Application.fetch_env!(:dau, :bsp)

    try do
      # {msg_id, delivery_params} = DeliveryReport.make_delivery_report_for_outbox(params) # Used before Turn Bsp

      {msg_id, delivery_params} = bsp.make_delivery_report_for_outbox(params)

      case UserMessage.add_delivery_report_by_eid(msg_id, delivery_params) do
        {:ok, _} ->
          Logger.info("report added to db")

        {:error, reason} ->
          Logger.error(reason)
      end

      Task.async(fn -> Analytics.create_delivery_event(params) end)

      conn
      |> put_resp_content_type("application/json")
      |> resp(200, Jason.encode!(%{status: :ok}))
      |> send_resp()
    rescue
      _err ->
        conn
        |> put_resp_content_type("application/json")
        |> resp(400, Jason.encode!(%{status: :invalid_request}))
        |> send_resp()

        # Message.send(:dau_alerts, "invalid_delivery_report", "Invalid delivery report", params)
    end

    # |> Plug.Conn.send_resp(200, Jason.encode(%{}))
  end

  def send_400(conn) do
    conn
    |> put_resp_content_type("application/json")
    |> resp(400, Jason.encode!(%{status: :invalid_request}))
    |> send_resp()
  end
end
