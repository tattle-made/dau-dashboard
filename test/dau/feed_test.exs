defmodule DAU.FeedTest do
  use DAU.DataCase

  alias DAU.UserMessageFixtures
  alias DAU.FeedFixtures

  describe "inbox and common" do
    test "add message from inbox to common" do
      _feed_of_five = FeedFixtures.common_feed_of_five()

      # IO.inspect(feed_of_five)
    end

    test "inbox and common association" do
      _inbox_video_message = UserMessageFixtures.inbox_video_message_fixture()
      _common = FeedFixtures.common()

      # inbox_message =
      #   Inbox
      #   |> Repo.get!(inbox_video_message.id)
      #   |> Repo.preload(:query)

      # {:ok, inbox_message} =
      #   inbox_video_message
      #   |> Repo.preload(:query)
      #   |> change()
      #   |> put_assoc(:query, common)
      #   |> Repo.update()

      # IO.inspect(common)
      # IO.inspect(inbox_message)

      # assert inbox_message.query.id == common.id
      # assert inbox_message.query.media_urls == common.media_urls

      # common =
      #   Common
      #   |> Repo.get(common.id)
      #   |> Repo.preload(:messages)

      # IO.inspect(common)
      # data =
      #   inbox_message
      #   |> put_assoc(:query, common)
      #   |> Repo.update()

      # inbox =
      #   Inbox
      #   |> Inbox.changeset(%{})
      #   |> Repo.insert()

      # IO.inspect(inbox_message)
      # IO.inspect(common)
      # IO.inspect(test)
      # IO.inspect(data)
    end
  end
end
