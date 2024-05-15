defmodule DAU.UserMessage.ConversationTest do
  alias DAU.MediaMatch
  alias DAU.MediaMatch.Blake2b.EventConversationCreated
  alias DAU.UserMessage
  use DAU.DataCase

  describe "User sends a message for the first time" do
    setup do
      payload = %{
        "media_type" => "audio",
        "path" => "https://example.com/audio-01.mp4",
        "sender_name" => "sender a",
        "sender_number" => "919999999990",
        "user_language_input" => "hi"
      }

      {:ok, conversation_created} = UserMessage.Conversation.add_message(payload)
      conversation = UserMessage.Conversation.get(conversation_created.id)

      %{conversation: conversation}
    end

    test "add message", %{conversation: conversation} do
      payload = %{
        "media_type" => "audio",
        "path" => "https://example.com/audio-01.mp4",
        "sender_name" => "sender a",
        "sender_number" => "919999999990",
        "user_language_input" => "hi"
      }

      {:ok, conversation_created} = UserMessage.Conversation.add_message(payload)

      assert %EventConversationCreated{id: id, path: path, media_type: "audio"} =
               conversation_created
    end

    test "associate common with hashmeta" do
      alias DAU.MediaMatch.Blake2B.Media

      media =
        Media.new()
        |> Media.set_hash("sadf-asdfasdf-")
        |> Media.set_inbox_id(1)
        |> Media.set_language(:en)

      hash = MediaMatch.Blake2B.save_hash(media)
    end
  end
end
