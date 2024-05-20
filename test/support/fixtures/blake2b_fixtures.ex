defmodule DAU.Blake2BFixtures do
  def make_response_string(:video, message_id) do
    "{\"indexer_id\":1,\"post_id\":#{message_id},\"media_type\":\"video\",\"hash_value\":\"ABDSADJSDFSDF-AFASDFSDF-ASDFSDFSDFFSDF\",\"status\":\"indexed\",\"status_code\":200}"
  end

  def make_response_string(:audio, message_id) do
    "{\"indexer_id\":1,\"post_id\":#{message_id},\"media_type\":\"audio\",\"hash_value\":\"ABDSADJSDFSDF-AFASDFSDF-ASDFSDFSDFFSDF\",\"status\":\"indexed\",\"status_code\":200}"
  end
end
