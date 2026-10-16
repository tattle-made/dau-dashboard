defmodule DAU.UserMessage.ConversationBlake2BTest do
  alias DAU.MediaMatch.Blake2B
  alias DAU.MediaMatch.Blake2B.Media
  alias DAU.MediaMatch.HashWorkerResponse
  alias DAU.Blake2BFixtures
  alias DAU.UserMessageFixtures
  alias DAU.UserMessage.Conversation.MessagePropertiesAdded
  alias DAU.UserMessage.Conversation
  alias DAU.UserMessage
  alias DAU.MediaMatch
  alias DAU.Repo
  alias DAU.Feed.Common
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


      {:ok, message_added} = UserMessage.Conversation.add_to_inbox(payload) |> elem(1) |> UserMessage.Conversation.add_message_properties()

      assert %MessagePropertiesAdded{id: id, path: path, media_type: "audio"} =
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

      {:ok, message_added} = Conversation.add_to_inbox(payload) |> elem(1) |> Conversation.add_message_properties()
      {:ok, conversation} = Conversation.build(message_added.id)

      %{conversation: conversation, message_added: message_added}
    end

    test "associate common with hashmeta", %{
      conversation: conversation,
      message_added: message_added
    } do
      args = Blake2BFixtures.make_response_args(:video, message_added.id)

      assert {:ok, :ok} = Blake2B.worker_response_received(args)

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
        |> Enum.map(&(Conversation.add_to_inbox(&1) |> elem(1) |> Conversation.add_message_properties() |> elem(1)))
        |> Enum.map(&(Conversation.build(&1.id) |> elem(1)))

      %{conversations: conversations}
    end

    test "count", %{conversations: conversations} do
      conversations
      |> Enum.map(&Conversation.get_first_message(&1))
      |> Enum.map(&Blake2BFixtures.make_response_args(:video, &1.id))
      |> Enum.map(&Blake2B.worker_response_received(&1))

      counts =
        conversations
        |> Enum.map(&Conversation.get_media_count(&1))

      assert [3, 1, 3, 3] == counts
    end
  end

  describe "Auto tag incoming media as spam, if an exisiting duplicate is marked as spam" do
    setup do
      # Create an exisiting data entry with verification_status as :spam
      existing_message = %{
        "media_type" => "video",
        "path" => "https://example.com/vid.mp4",
        "sender_number" => "1234567890",
        "sender_name" => "atm",
        "user_language_input" => "hi"
      }

      {:ok, existing_conversation} = Conversation.add_to_inbox(existing_message) |> elem(1) |> Conversation.add_message_properties()
      existing_message_id = existing_conversation.id
      existing_args = Blake2BFixtures.make_response_args(:video, existing_message_id)
      {:ok, :ok} = Blake2B.worker_response_received(existing_args)
      {:ok, existing_query} = Conversation.get(existing_conversation.id)
      {:ok, existing_conversation_build} = Conversation.build(existing_query)
      existing_common = Repo.get!(Common, existing_conversation_build.feed_id)
      existing_common |> Common.changeset(%{verification_status: :spam}) |> Repo.update()

      # Create an incoming data entry
      incoming_message = %{
        "media_type" => "video",
        "path" => "https://example.com/vid.mp4",
        "sender_number" => "1234567890",
        "sender_name" => "atm",
        "user_language_input" => "hi"
      }

      {:ok, incoming_conversation} = Conversation.add_to_inbox(incoming_message) |> elem(1) |> Conversation.add_message_properties()
      incoming_message_id = incoming_conversation.id
      incoming_args = Blake2BFixtures.make_response_args(:video, incoming_message_id)
      {:ok, incoming_response} = HashWorkerResponse.new(incoming_args)

      incoming_media =
        Media.build(incoming_response, UserMessage.get_incoming_message!(incoming_message_id))

      {:ok, incoming_query} = Conversation.get(incoming_conversation.id)
      {:ok, incoming_conversation_build} = Conversation.build(incoming_query)

      %{incoming_conversation_build: incoming_conversation_build, incoming_media: incoming_media}
    end

    test "test a", state do
      Blake2B.auto_tag_spam(state.incoming_conversation_build, state.incoming_media)
      incoming_media_feed_common = Repo.get!(Common, state.incoming_conversation_build.feed_id)
      assert incoming_media_feed_common.verification_status == :spam
    end
  end
end
