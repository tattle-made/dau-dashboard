defmodule DAU.UserMessage.ConversationBlake2BTest do
  alias DAU.Blake2BFixtures
  alias DAU.UserMessageFixtures
  alias DAU.Feed.Common
  alias DAU.UserMessage.Conversation.MessageAdded
  alias DAU.MediaMatch
  alias DAU.UserMessage
  use DAU.DataCase

  describe "User sends a message for the first time" do
    test "add message" do
      payload = %{
        "media_type" => "audio",
        "path" => "https://example.com/audio-01.mp4",
        "sender_name" => "sender a",
        "sender_number" => "919999999990",
        "user_language_input" => "hi"
      }

      {:ok, message_added} = UserMessage.Conversation.add_message(payload)

      assert %MessageAdded{id: id, path: path, media_type: "audio"} =
               message_added
    end
  end

  describe "Associate hashmeta with an existing conversation" do
    alias UserMessage.Conversation
    alias MediaMatch.Blake2B

    setup do
      payload = %{
        "media_type" => "audio",
        "path" => "https://example.com/audio-01.mp4",
        "sender_name" => "sender a",
        "sender_number" => "919999999990",
        "user_language_input" => "hi"
      }

      {:ok, message_added} = Conversation.add_message(payload)
      {:ok, conversation} = Conversation.build(message_added.id)

      %{conversation: conversation, message_added: message_added}
    end

    test "associate common with hashmeta", %{
      conversation: conversation,
      message_added: message_added
    } do
      alias DAU.MediaMatch.Blake2B.Media

      # IO.inspect(conversation)

      response_string =
        "{\"indexer_id\":1,\"post_id\":#{message_added.id},\"media_type\":\"video\",\"hash_value\":\"ABDSADJSDFSDF-AFASDFSDF-ASDFSDFSDFFSDF\",\"status\":\"indexed\",\"status_code\":200}"

      # IO.inspect(response_string)

      assert {:ok} = Blake2B.worker_response_received(response_string)

      {:ok, conversation} = Conversation.build(message_added.id)
      count = Conversation.get_media_count(conversation)

      assert count == 1
    end
  end

  describe "Count repeat requests. Include language variation" do
    alias UserMessage.Conversation
    alias MediaMatch.Blake2B

    setup do
      payloads = [
        UserMessageFixtures.inbox_message_attrs(:video, %{"user_language_input" => "hi"}),
        UserMessageFixtures.inbox_message_attrs(:video, %{"user_language_input" => "en"}),
        UserMessageFixtures.inbox_message_attrs(:video, %{"user_language_input" => "hi"}),
        UserMessageFixtures.inbox_message_attrs(:video, %{"user_language_input" => "hi"})
      ]

      conversations =
        payloads
        |> Enum.map(&(Conversation.add_message(&1) |> elem(1)))
        |> Enum.map(&(Conversation.build(&1.id) |> elem(1)))

      %{conversations: conversations}
    end

    test "count", %{conversations: conversations} do
      conversations
      |> Enum.map(&Conversation.get_first_message(&1))
      |> Enum.map(&Blake2BFixtures.make_response_string(:video, &1.id))
      |> Enum.map(&Blake2B.worker_response_received(&1))

      counts =
        conversations
        |> Enum.map(&Conversation.get_media_count(&1))

      assert [3, 1, 3, 3] == counts
    end
  end
end
