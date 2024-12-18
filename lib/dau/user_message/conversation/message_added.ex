defmodule DAU.UserMessage.Conversation.MessagePropertiesAdded do
  @derive Jason.Encoder
  defstruct [:id, :common_id, :path, :media_type]
end
