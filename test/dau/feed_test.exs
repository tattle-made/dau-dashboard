defmodule DAU.FeedTest do
  alias DAU.Feed
  alias DAU.Feed.Common
  alias DAU.Feed.AssessmentReport
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

  describe "User response button should become clickable only after a label has been added" do
    setup do
      common_wo_label_wo_ar_wo_fc =
        %Common{}
        |> Common.changeset(%{
          media_urls: ["https://example.com/video1.mp4"],
          media_type: :video,
          sender_number: "1234567890"
        })
        |> Repo.insert!()

      common_w_label_wo_ar_wo_fc =
        %Common{}
        |> Common.changeset(%{
          media_urls: ["https://example.com/video1.mp4"],
          media_type: :video,
          sender_number: "1234567890",
          verification_status: :deepfake
        })
        |> Repo.insert!()

      common_w_label_w_ar_wo_fc =
        %Common{}
        |> Common.changeset(%{
          media_urls: ["https://example.com/video1.mp4"],
          media_type: :video,
          sender_number: "1234567899",
          verification_status: :deepfake
        })
        |> Common.query_with_assessment_report_changeset(%AssessmentReport{
          url: "https://example.com/assessment_report"
        })
        |> Repo.insert!()

      {:ok,
       common_wo_label_wo_ar_wo_fc: common_wo_label_wo_ar_wo_fc,
       common_w_label_wo_ar_wo_fc: common_w_label_wo_ar_wo_fc,
       common_w_label_w_ar_wo_fc: common_w_label_w_ar_wo_fc}
    end

    test "enable approve response button", state do
      valid_template_common_wo_label_wo_ar_wo_fc =
        Feed.enable_approve_response?(state.common_wo_label_wo_ar_wo_fc)

      assert valid_template_common_wo_label_wo_ar_wo_fc == false

      valid_template_common_w_label_wo_ar_wo_fc =
        Feed.enable_approve_response?(state.common_w_label_wo_ar_wo_fc)

      assert valid_template_common_w_label_wo_ar_wo_fc == false

      valid_template_common_w_label_w_ar_wo_fc =
        Feed.enable_approve_response?(state.common_w_label_w_ar_wo_fc)

      assert valid_template_common_w_label_w_ar_wo_fc == true
    end
  end

  describe "block urls from certain domains" do
    setup do
      %{}
    end

    test "test on different urls" do
      blocked_urls = [
        # Standard domains
        "https://amazon.com",
        "http://amazon.in",
        "amazon.in",
        "myntra.in",
        "www.myntra.com",
        "amazon.co.in",
        "myntra.co.in",
        "flipkart.in",
        # Subdomains
        "shop.amazon.com",
        "aws.amazon.com",
        "www.myntra.com",
        "store.myntra.in",
        "hop.amznin.co.in",
        # URLs with paths and query parameters
        "https://www.amazon.com/product/details",
        "flipkart.com/electronics?category=phones",
        "https://myntra.com/men/shirts?brand=levis",
        # URLs with additional parameters
        "https://amazon.in@amznin.cyou/?a=71716710208694",
        "https://flipkart.com@flipkin.cyou/?festival-day-gift=71716615491518",
        # Embedded in text
        "Check out this link: amazon.com for great deals",
        "Visit www.myntra.com for the latest fashion",
        "Hi, can you check this for me? amazon.com",
        "amazon.co.in is the new shopping website, check it out!!",
        # Text with multiple domains
        "This text contains multiple domains: www.amazon.com and www.google.com",
        # Complex URLs
        "https://seller.amazon.co.in/marketplace",
        "http://international.flipkart.com/global-store",
        # URLs with ports (though uncommon)
        "http://amazon.com:8080/path"
      ]

      # URLs that should return false (not blocked)
      non_blocked_urls = [
        # Different domains
        "https://google.com",
        "www.github.com",
        "facebook.com",
        "linkedin.com",
        "www.google.com",
        "google.com",
        "help.com",
        "here is the website google.com",
        "can you check this for me facebook.com",
        "google.com is the webpage, check it out",
        "what is up with google.com, is it down? this is the site www.google.com",
        # URLs mentioning blocked domains (not in domain)
        "https://factcheck-site.com/article-about-amazon-com",
        "randomsite.com/amazon-review",
        "blog.example.com/myntra-fashion-trends",
        # random text
        "A blog post discussing myntra's business model",
        "a shoping website called flipkart",
        "hi, how are you?",
        "this is some text for testing -- testing",
        "what is this tipline about??, I am curious",
        # Unusual formats
        "localhost",
        "127.0.0.1",
        "subdomain.randomsite.com",
        # Potential typo domains
        "amaz0n.com",
        "myntr.com",
        "flipcart.com"
      ]

      # Test all blocked URLs return true
      Enum.each(blocked_urls, fn url ->
        assert Feed.block_specific_urls?(url) == true,
               "Failed to block URL: #{url}"
      end)

      # Test all non-blocked URLs return false
      Enum.each(non_blocked_urls, fn url ->
        assert Feed.block_specific_urls?(url) == false,
               "Incorrectly blocked URL: #{url}"
      end)
    end
  end
end
