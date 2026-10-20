defmodule DAU.ObanSchemaTest do
  use DAU.DataCase

  alias DAU.MediaMatch
  alias DAU.MediaMatch.HashMeta
  alias DAU.UserMessageFixtures

  test "hash values longer than 255 characters are stored" do
    inbox = UserMessageFixtures.inbox_video_message_fixture()
    value = String.duplicate("A", 1400)

    assert {:ok, hash} =
             MediaMatch.create_hash(%{value: value, inbox_id: inbox.id, user_language: :en})

    assert String.length(hash.value) == 1400

    assert {:ok, hash_meta} =
             MediaMatch.create_hashmeta(%{value: value, user_language: :en, count: 1})

    assert String.length(Repo.get!(HashMeta, hash_meta.id).value) == 1400
  end
end
