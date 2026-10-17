defmodule DAU.MediaMatchTest do
  alias DAU.MediaMatch.Hash
  alias DAU.UserMessageFixtures
  alias DAU.MediaMatch
  use DAU.DataCase

  alias DAU.FeedFixtures

  describe "user response" do
    alias DAU.UserMessageFixtures

    setup do
      feed = FeedFixtures.common_feed_of_five()

      {:ok, datetime} = DateTime.new(~D[2024-03-25], ~T[08:30:00.000], "Etc/UTC")

      # create user messages (new rows in user_message_inbox)
      _message =
        UserMessageFixtures.inbox_message_with_date_fixture(%{
          inserted_at: datetime,
          updated_at: datetime
        })

      # use UserMessage context to add this message to a query
      # use UserMessage context to add this query to common_feed

      # IO.inspect(message)

      %{feed: feed}
    end

    test "add message to outbox for query within 24 hours" do
      # IO.inspect(context.feed)
      # input : feed_common_id, user_message_inbox_id
      # get user_message_inbox inserted_at

      # get an item from feed and add its response
      # for that item, find matching queries that were sent within 24 hours
      # create an entry for them in the user_message_outbox
      # assert the text in outbox and sent status
      #
    end

    test "add message to outbox for query after 24 hours" do
    end
  end

  describe "hash" do
    setup do
      inbox = UserMessageFixtures.inbox_video_message_fixture()
      %{inbox: inbox}
    end

    test "create valid hash", %{inbox: inbox} do
      assert {:ok, %Hash{} = hash} =
               MediaMatch.create_hash(%{
                 inbox_id: inbox.id,
                 value: "asdfasdfdfa",
                 user_language: :en,
                 worker_version: "feluda@0.1"
               })

      assert hash.inbox_id == inbox.id
    end

    test "create invalid hash" do
      assert {:error, %Ecto.Changeset{}} =
               MediaMatch.create_hash(%{inbox_id: 12, value: "asdfasdfdfa", version: 1})
    end
  end
end
