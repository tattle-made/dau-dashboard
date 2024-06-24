defmodule DAU.UserMessage.Conversation.MessageAdded do
  @derive Jason.Encoder
  defstruct [:id, :common_id, :path, :media_type]
end
