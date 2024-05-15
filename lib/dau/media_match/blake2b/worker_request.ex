defmodule DAU.MediaMatch.Blake2b.WorkerRequest do
  alias DAU.MediaMatch.Blake2b.WorkerRequest
  alias DAU.UserMessage.Conversation.EventConversationCreated

  @derive Jason.Encoder
  defstruct [:id, :path, :media_type]

  def new(%EventConversationCreated{} = conversation_created) do
    %WorkerRequest{
      id: conversation_created.id,
      path: conversation_created.path,
      media_type: conversation_created.media_type
    }
  end
end
