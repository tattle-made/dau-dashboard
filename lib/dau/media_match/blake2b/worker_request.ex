defmodule DAU.MediaMatch.Blake2b.WorkerRequest do
  alias DAU.MediaMatch.Blake2b.WorkerRequest
  alias DAU.UserMessage.Conversation.MessagePropertiesAdded

  @derive Jason.Encoder
  defstruct [:id, :path, :media_type]

  def new(%MessagePropertiesAdded{} = message_added) do
    %WorkerRequest{
      id: message_added.id,
      path: message_added.path,
      media_type: message_added.media_type
    }
  end
end
