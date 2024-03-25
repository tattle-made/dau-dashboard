defmodule DAU.FeedTest do
  alias DAU.UserMessageFixtures
  alias DAU.UserMessage.Inbox
  alias DAU.FeedFixtures
  use DAU.DataCase

  alias DAU.Feed

  describe "inbox and common" do
    test "add message from inbox to common" do
      feed_of_five = FeedFixtures.common_feed_of_five()

      # IO.inspect(feed_of_five)
    end

    test "inbox and common association" do
      inbox_video_message = UserMessageFixtures.inbox_video_message_fixture()
      full_message = Repo.preload(inbox_video_message, :query)

      # inbox =
      #   Inbox
      #   |> Inbox.changeset(%{})
      #   |> Repo.insert()

      IO.inspect(full_message)
    end
  end
end
