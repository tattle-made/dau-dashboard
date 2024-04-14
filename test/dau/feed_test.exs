defmodule DAU.FeedTest do
  alias DAU.Feed
  alias DAU.Feed.Common
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

  describe "factcheck article approval" do
    setup do
      feed_common =
        Ecto.Changeset.change(
          %Common{},
          media_urls: ["temp/audio-01.wav"],
          media_type: :audio,
          language: :en,
          factcheck_articles: [
            %{username: "contributor_one", url: "https://site-one.com/article-one"},
            %{username: "contributor_two", url: "https://site-two.com/article-two"}
          ]
        )
        |> Repo.insert!()

      %{feed_common: feed_common}
    end

    test "approve fact check article", %{feed_common: feed_common} do
      assert length(feed_common.factcheck_articles) == 2
      article_one = Enum.at(feed_common.factcheck_articles, 0)
      assert article_one.approved == false

      {:ok, common} = Feed.set_approval_status(feed_common.id, article_one.id, true)
      new_article_one = Enum.at(common.factcheck_articles, 0)
      assert new_article_one.id == article_one.id
      assert new_article_one.approved == true
    end

    test "reject fact check article", %{feed_common: feed_common} do
      assert length(feed_common.factcheck_articles) == 2
      article_one = Enum.at(feed_common.factcheck_articles, 0)
      assert article_one.approved == false

      {:ok, common} = Feed.set_approval_status(feed_common.id, article_one.id, false)
      new_article_one = Enum.at(common.factcheck_articles, 0)
      assert new_article_one.id == article_one.id
      assert new_article_one.approved == false
    end
  end
end
