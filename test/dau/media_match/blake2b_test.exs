defmodule DAU.MediaMatch.Blake2bTest do
  alias DAU.MediaMatch.Blake2B
  use DAU.DataCase

  test "build from string" do
    attrs =
      "{\"indexer_id\":1,\"post_id\":1,\"media_type\":\"video\",\"hash_value\":\"ABDSADJSDFSDF-AFASDFSDF-ASDFSDFSDFFSDF\",\"status\":\"indexed\",\"status_code\":200}"

    {:ok, response} = Blake2B.build(attrs)

    attrs = %{
      "hash_value" => "ABDSADJSDFSDF-AFASDFSDF-ASDFSDFSDFFSDF",
      "indexer_id" => 1,
      "media_type" => "video",
      "post_id" => 1,
      "status" => "indexed",
      "status_code" => 200
    }

    {:ok, response} = Blake2B.build(attrs)
    IO.inspect(response)
  end
end
