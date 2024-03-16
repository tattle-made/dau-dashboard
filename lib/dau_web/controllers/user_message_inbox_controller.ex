defmodule DAUWeb.IncomingMessageController do
  use DAUWeb, :controller

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
    with {:ok, %Inbox{} = inbox_message} <- UserMessage.create_incoming_message(payload) do
      {file_key, file_hash} =
        FileManager.upload_to_s3(payload["path"])

      UserMessage.update_user_message_file_metadata(inbox_message, %{
        file_key: file_key,
        file_hash: file_hash
      })

      Feed.add_to_common_feed(%{
        media_urls: [file_key],
        media_type: inbox_message.media_type,
        sender_number: inbox_message.sender_number
      })

      conn
      |> Plug.Conn.send_resp(200, [])
    end
  end

  def show(conn, %{"id" => id}) do
    incoming_message = UserMessage.get_incoming_message!(id)
    render(conn, :show, incoming_message: incoming_message)
  end
end
