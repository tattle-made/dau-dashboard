defmodule DAU.UserMessage.InboxTest do
  alias DAU.UserMessage.Inbox
  use DAU.DataCase

  import DAU.UserMessageFixtures
  import DAU.QueryFixtures

  test "associate query to inbox" do
    inbox = inbox_video_message_fixture()
    query = query()

    inbox = Repo.get(Inbox, inbox.id) |> Repo.preload(:query)
    new_inbox = Inbox.associate_query_changeset(inbox, query) |> Repo.update!()

    assert new_inbox.id == inbox.id
    assert new_inbox.query_id == query.id
  end
end
