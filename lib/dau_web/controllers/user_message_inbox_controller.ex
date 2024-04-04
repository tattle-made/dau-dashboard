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
    IO.inspect(payload)

    with {:ok, %Inbox{} = inbox_message} <- UserMessage.create_incoming_message(payload) do
      media_type = inbox_message.media_type

      if Enum.member?(["video", "audio"], media_type) do
        {file_key, file_hash} =
          FileManager.upload_to_s3(payload["path"])

        UserMessage.update_user_message_file_metadata(inbox_message, %{
          file_key: file_key,
          file_hash: file_hash
        })

        Feed.add_to_common_feed(%{
          media_urls: [file_key],
          media_type: inbox_message.media_type,
          sender_number: inbox_message.sender_number,
          language: inbox_message.user_language_input
        })
      end

      if media_type == "text" do
        UserMessage.update_user_message_text_file_hash(inbox_message, %{
          file_hash:
            :crypto.hash(:sha256, inbox_message.user_input_text)
            |> Base.encode16()
            |> String.downcase()
        })

        Feed.add_to_common_feed(%{
          media_urls: [inbox_message.user_input_text],
          media_type: inbox_message.media_type,
          sender_number: inbox_message.sender_number,
          language: inbox_message.user_language_input
        })
      end

      conn
      |> Plug.Conn.send_resp(200, [])
    end
  end

  def show(conn, %{"id" => id}) do
    incoming_message = UserMessage.get_incoming_message!(id)
    render(conn, :show, incoming_message: incoming_message)
  end

  def receive_delivery_report(conn, payload) do
    IO.inspect(payload)
    conn |> Plug.Conn.send_resp(200, [])
  end
end
