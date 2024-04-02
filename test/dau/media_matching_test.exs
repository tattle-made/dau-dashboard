defmodule DAU.MediaMatchingTest do
  alias DAU.UserMessageFixtures
  use DAU.DataCase

  alias DAU.FeedFixtures

  describe "user response" do
    setup do
      feed = FeedFixtures.common_feed_of_five()

      {:ok, datetime} = DateTime.new(~D[2024-03-25], ~T[08:30:00.000], "Etc/UTC")

      # create user messages (new rows in user_message_inbox)
      message =
        UserMessageFixtures.inbox_message_with_date_fixture(%{
          inserted_at: datetime,
          updated_at: datetime
        })

      # use UserMessage context to add this message to a query
      # use UserMessage context to add this query to common_feed

      IO.inspect(message)

      %{feed: feed}
    end

    test "add message to outbox for query within 24 hours", context do
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
end
