defmodule DAUWeb.IncomingMessageController do
  use DAUWeb, :controller

  # alias DAU.Vendor.Slack.Message
  require Logger
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
          conn |> Plug.Conn.send_resp(200, [])
          message_added

        {:error, reason} ->
          raise reason
      end

    case MediaMatch.Blake2B.create_job(message_added) do
      :ok -> nil
      {:error, reason} -> raise reason
    end
  rescue
    error ->
      Logger.error("Error in controller for  POST /gupshup/message. #{inspect(error)}")
      Sentry.capture_exception(error, stacktrace: __STACKTRACE__)
      conn |> send_400()
  end

  # def create(conn, payload) do
  #   with {:ok, %Inbox{} = inbox_message} <- UserMessage.create_incoming_message(payload) do
  #     media_type = inbox_message.media_type

  #     if Enum.member?(["video", "audio"], media_type) do
  #       {file_key, file_hash} =
  #         AWSS3.upload_to_s3(payload["path"])

  #       UserMessage.update_user_message_file_metadata(inbox_message, %{
  #         file_key: file_key,
  #         file_hash: file_hash
  #       })

  #       {:ok, common} =
  #         Feed.add_to_common_feed(%{
  #           media_urls: [file_key],
  #           media_type: inbox_message.media_type,
  #           sender_number: inbox_message.sender_number,
  #           language: inbox_message.user_language_input
  #         })

  #       {:ok, query} = UserMessage.create_query_with_common(common, %{status: "pending"})
  #       {:ok, _inbox} = UserMessage.associate_inbox_to_query(inbox_message.id, query)

  #       case HashWorkerRequest.new(inbox_message) do
  #         {:ok, request} ->
  #           Logger.info("hash worker job added")
  #           # todo catch error for this function
  #           HashWorkerGenServer.add_to_job_queue(HashWorkerGenServer, request)

  #         {:error, error} ->
  #           Sentry.capture_message("#{error}. %s",
  #             interpolation_parameters: [inbox_message.id]
  #           )
  #       end
  #     end

  #     if media_type == "text" do
  #       UserMessage.update_user_message_text_file_hash(inbox_message, %{
  #         file_hash:
  #           :crypto.hash(:sha256, inbox_message.user_input_text)
  #           |> Base.encode16()
  #           |> String.downcase()
  #       })

  #       Feed.add_to_common_feed(%{
  #         media_urls: [inbox_message.user_input_text],
  #         media_type: inbox_message.media_type,
  #         sender_number: inbox_message.sender_number,
  #         language: inbox_message.user_language_input
  #       })
  #     end

  #     conn
  #     |> Plug.Conn.send_resp(200, [])
  #   end
  # end

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
