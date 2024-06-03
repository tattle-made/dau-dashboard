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
    message_added =
      case UserMessage.Conversation.add_message(payload) do
        {:ok, message_added} ->
          message_added

        {:error, reason} ->
          Logger.info("here 4")
          Logger.error(reason)
      end

    IO.inspect(message_added.media_type)

    if(message_added.media_type == "audio" or message_added.media_type == "video") do
      Task.async(fn -> MediaMatch.Blake2B.create_job(message_added) end)
    end

    conn |> Plug.Conn.send_resp(200, [])
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
    try do
      {msg_id, delivery_params} = DeliveryReport.make_delivery_report_for_outbox(params)

      case UserMessage.add_delivery_report(msg_id, delivery_params) do
        {:ok, _} ->
          Logger.info("report added to db")

        {:error, reason} ->
          Logger.error(reason)
      end

      Task.async(fn -> Analytics.save_delivery_event(params) end)

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
