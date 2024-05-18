defmodule DAU.MediaMatch.Blake2b.Match do
  alias DAU.MediaMatch.Blake2b.Match
  alias DAU.UserMessage.Conversation

  @derive Jason.Encoder
  defstruct [:feed_id, :language, :messages, :response]

  def new(%Conversation{} = conversation) do
    %Match{
      feed_id: conversation.feed_id,
      language: conversation.language,
      messages: conversation.messages,
      response: conversation.response
    }
  end
end
