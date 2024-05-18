defmodule DAU.UserMessage.Conversation.Hash do
  alias DAU.UserMessage.Conversation.Hash, as: ConversationHash
  alias DAU.MediaMatch.Hash

  defstruct [:id, :language, :value]

  def new(%Hash{} = hash) do
    %ConversationHash{
      id: hash.id,
      language: hash.user_language,
      value: hash.value
    }
  end

  def new(nil), do: nil
end
