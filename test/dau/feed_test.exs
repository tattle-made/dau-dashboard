defmodule DAU.FeedTest do
  alias DAU.FeedFixtures
  use DAU.DataCase

  alias DAU.Feed

  describe "inbox and common" do
    test "add message from inbox to common" do
      feed_of_five = FeedFixtures.common_feed_of_five()

      IO.inspect(feed_of_five)
    end
  end
end
