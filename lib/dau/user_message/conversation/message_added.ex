defmodule DAU.UserMessage.Conversation.MessageAdded do
  @derive Jason.Encoder
  defstruct [:id, :path, :media_type]
end
