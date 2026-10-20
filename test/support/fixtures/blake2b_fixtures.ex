defmodule DAU.Blake2BFixtures do
  def make_response_args(media_type, message_id) when media_type in [:video, :audio] do
    %{
      "inbox_id" => message_id,
      "media_type" => Atom.to_string(media_type),
      "hash_value" => "ABDSADJSDFSDF-AFASDFSDF-ASDFSDFSDFFSDF",
      "worker_version" => "blake2b"
    }
  end
end
