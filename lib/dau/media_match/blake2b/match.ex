defmodule DAU.MediaMatch.Blake2b.Match do
  alias DAU.MediaMatch.Blake2b.Match
  alias DAU.UserMessage.Conversation

  @derive Jason.Encoder
  defstruct [:feed_id, :language, :messages, :response, :sender_number, :verification_status]

  def new(%Conversation{} = conversation) do
    %Match{
      feed_id: conversation.feed_id,
      language: conversation.language,
      messages: conversation.messages,
      response: conversation.response,
      sender_number: conversation.sender_number,
      verification_status: conversation.verification_status
    }
  end
end
