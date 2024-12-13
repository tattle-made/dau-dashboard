alias DAU.MediaMatch.Blake2B
alias DAU.UserMessage.Conversation

defmodule Helpers do
  def get_unique_string(n),
    do: for(_ <- 1..n, into: "", do: <<Enum.random(~c"0123456789abcdef")>>)

  def get_unique_phone_number(),
    do: for(_ <- 1..10, into: "", do: <<Enum.random(~c"0123456789")>>)

  def make_response_string(:video, message_id) do
    "{\"indexer_id\":1,\"post_id\":#{message_id},\"media_type\":\"video\",\"hash_value\":\"ABDSADJSDFSDF-AFASDFSDF-ASDFSDFSDFFSDF\",\"status\":\"indexed\",\"status_code\":200}"
  end

  def make_response_string(:audio, message_id) do
    "{\"indexer_id\":1,\"post_id\":#{message_id},\"media_type\":\"audio\",\"hash_value\":\"ABDSADJSDFSDF-AFASDFSDF-ASDFSDFSDFFSDF\",\"status\":\"indexed\",\"status_code\":200}"
  end
end

payloads = [
  %{
    "media_type" => "video",
    "user_language_input" => "hi",
    "path" => "https://example.com/#{Helpers.get_unique_string(5)}.mp4",
    "sender_number" => Helpers.get_unique_phone_number(),
    "sender_name" => Helpers.get_unique_string(6)
  },
  %{
    "media_type" => "video",
    "user_language_input" => "hi",
    "path" => "https://example.com/#{Helpers.get_unique_string(5)}.mp4",
    "sender_number" => Helpers.get_unique_phone_number(),
    "sender_name" => Helpers.get_unique_string(6)
  },
  %{
    "media_type" => "video",
    "user_language_input" => "hi",
    "path" => "https://example.com/#{Helpers.get_unique_string(5)}.mp4",
    "sender_number" => Helpers.get_unique_phone_number(),
    "sender_name" => Helpers.get_unique_string(6)
  },
  %{
    "media_type" => "video",
    "user_language_input" => "hi",
    "path" => "https://example.com/#{Helpers.get_unique_string(5)}.mp4",
    "sender_number" => Helpers.get_unique_phone_number(),
    "sender_name" => Helpers.get_unique_string(6)
  }
]

conversations =
  payloads
  |> Enum.map(&(Conversation.add_message(&1, :message_added) |> elem(1)))
  |> Enum.map(&(Conversation.build(&1.id) |> elem(1)))

conversations
|> Enum.map(&Conversation.get_first_message(&1))
|> Enum.map(&Helpers.make_response_string(:video, &1.id))
|> Enum.map(&Blake2B.worker_response_received(&1))
