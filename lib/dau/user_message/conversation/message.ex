defmodule DAU.UserMessage.Conversation.Message do
  alias DAU.UserMessage.Inbox
  alias DAU.UserMessage.Conversation.Message

  defstruct [:id, :file_key, :media_type]

  def new() do
    %Message{}
  end

  def new(%Inbox{} = inbox) do
    Message.new()
    |> set_id(inbox.id)
    |> set_file_key(inbox.file_key)
    |> set_media_type(inbox.media_type)
  end

  def set_id(%Message{} = message, id) do
    %{message | id: id}
  end

  def set_file_key(%Message{} = message, file_key) do
    %{message | file_key: file_key}
  end

  def set_media_type(%Message{} = message, media_type) do
    %{message | media_type: media_type}
  end
end
