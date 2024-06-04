defmodule DAU.Temp do
  use DAU.DataCase
  alias DAU.UserMessage.Conversation
  alias DAU.Blake2BFixtures
  alias DAU.MediaMatch.Blake2B
  alias DAU.MediaMatch.Blake2B.Media
  alias DAU.Feed
  alias DAU.Feed.Common
  alias DAU.Repo

  # describe "Using Media Matching to auto-tag SPAM content" do
  #   setup do
  #     ## Create an exisiting data entry with verification_status as :spam
  #     existing_message = %{
  #       "media_type" => "video",
  #       "path" => "https://example.com/vid.mp4",
  #       "sender_number" => "1234567890",
  #       "sender_name" => "atm",
  #       "user_language_input" => "hi"
  #     }

  #     {:ok, existing_conversation} = Conversation.add_message(existing_message)
  #     existing_message_id = existing_conversation.id
  #     existing_response_string = Blake2BFixtures.make_response_string(:video, existing_message_id)
  #     existing_worker_func = Blake2B.worker_response_received(existing_response_string)
  #     existing_media = Media.build(existing_response_string)
  #     {:ok, existing_query} = Conversation.get(existing_conversation.id)
  #     existing_conversation_build = Conversation.build(existing_query)
  #     existing_common = Repo.get!(Common, existing_conversation_build.feed_id)
  #     existing_common |> Common.changeset(%{verification_status: :spam}) |> Repo.update()
  #     # existing_common = Repo.get!(Common, existing_conversation_build.feed_id)

  #     ## Create an incoming data entry
  #     incoming_message = %{
  #       "media_type" => "video",
  #       "path" => "https://example.com/vid.mp4",
  #       "sender_number" => "1234567890",
  #       "sender_name" => "atm",
  #       "user_language_input" => "hi"
  #     }

  #     {:ok, incoming_conversation} = Conversation.add_message(incoming_message)
  #     incoming_message_id = incoming_conversation.id
  #     incoming_response_string = Blake2BFixtures.make_response_string(:video, incoming_message_id)
  #     incoming_worker_func = Blake2B.worker_response_received(incoming_response_string)
  #     incoming_media = Media.build(incoming_response_string)
  #     {:ok, incoming_query} = Conversation.get(incoming_conversation.id)
  #     incoming_conversation_build = Conversation.build(incoming_query)
  #     incoming_feed_id = incoming_conversation_build.feed_id

  #     {:ok, incoming_media: incoming_media, incoming_feed_id: incoming_feed_id}
  #   end

  #   test "test a", state do
  #     matches_found = Blake2B.get_matches(state.incoming_media)
  #     IO.inspect(matches_found)
  #     IO.inspect(Repo.get!(Common, state.incoming_feed_id), label: "BEFORE COMMON")

  #     if Enum.any?(matches_found, fn match -> match.verification_status == :spam end) do
  #       IO.puts("Spam found")
  #       Feed.change_verification_status_to_spam(state.incoming_feed_id)
  #       IO.inspect(Repo.get!(Common, state.incoming_feed_id), label: "AFTER COMMON")
  #     else
  #       IO.puts("No spam detected.")
  #     end
  #   end
  # end

  describe "test the worker func in Blake2B" do
    setup do
      ## Create an exisiting data entry with verification_status as :spam
      existing_message = %{
        "media_type" => "video",
        "path" => "https://example.com/vid.mp4",
        "sender_number" => "1234567890",
        "sender_name" => "atm",
        "user_language_input" => "hi"
      }

      {:ok, existing_conversation} = Conversation.add_message(existing_message)
      existing_message_id = existing_conversation.id
      existing_response_string = Blake2BFixtures.make_response_string(:video, existing_message_id)
      existing_worker_func = Blake2B.worker_response_received(existing_response_string)
      existing_media = Media.build(existing_response_string)
      {:ok, existing_query} = Conversation.get(existing_conversation.id)
      existing_conversation_build = Conversation.build(existing_query)
      existing_common = Repo.get!(Common, existing_conversation_build.feed_id)
      existing_common |> Common.changeset(%{verification_status: :spam}) |> Repo.update()

      incoming_message = %{
        "media_type" => "video",
        "path" => "https://example.com/vid.mp4",
        "sender_number" => "1234567890",
        "sender_name" => "atm",
        "user_language_input" => "hi"
      }

      {:ok, incoming_conversation} = Conversation.add_message(incoming_message)
      incoming_message_id = incoming_conversation.id
      incoming_response_string = Blake2BFixtures.make_response_string(:video, incoming_message_id)

      %{incoming_response_string: incoming_response_string}
    end

    test "test a", state do
      incoming_worker_func = Blake2B.worker_response_received(state.incoming_response_string)
    end
  end
end
