defmodule DAU.Temp do
  use DAU.DataCase
  alias DAU.UserMessage.Conversation
  alias DAU.Blake2BFixtures
  alias DAU.MediaMatch.Blake2B
  alias DAU.MediaMatch.Blake2B.Media

  describe "Using Media Matching to auto-tag SPAM content" do
    setup do
      message = %{
        "media_type" => "video",
        "path" => "https://example.com/vid.mp4",
        "sender_number" => "1234567890",
        "sender_name" => "atm",
        "user_language_input" => "hi"
      }

      {:ok, conversation} = Conversation.add_message(message)
      message_id = conversation.id
      response_string = Blake2BFixtures.make_response_string(:video, message_id)
      worker_func = Blake2B.worker_response_received(response_string)
      media = Media.build(response_string)

      {:ok, media: media}
    end

    test "test a", state do
      matches_found = Blake2B.get_matches(state.media)
      IO.inspect(matches_found)
    end
  end
end
