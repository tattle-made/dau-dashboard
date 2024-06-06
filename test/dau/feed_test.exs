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
      urls = [
        "https://amazon.in@amznin.cyou/?a=71716710208694",
        "https://www.amazon.in/Redmi-Starlight-Storage-MediaTek-Dimensity/dp/B0CNX89QR8/?_encoding=UTF8&ref_=dlx_gate_sd_dcl_tlt_5db6bdf8_dt_pd_hp_d_atf_unk",
        "https://amazon.in@amznin.cyou/?a=71716708185229",
        "https://flipkart.com@flipkin.cyou/?festival-day-gift=71716615491518",
        "https://www.flipkart.com/laptop-accessories/keyboards/pr?sid=6bo%2Cai3%2C3oe&sort=popularity&param=33&hpid",
        "https://myntra.com@mnatry.cyou/?in=91716519824017",
        "https://www.myntra.com/shirts/arrow/arrow-spread-collar-slim-fit-opaque-striped-cotton-formal-shirt/28506318/buy",
        "hey, is this real? https://www.amazon.com/adfasdfadf",
        "https://www.amazon.com/adfasdfadf Can you check this for me?",
        "Some text before link https://www.amazon.com/adfasdfadf Can you check this for me?"
      ]

      assert Enum.all?(urls, &Feed.block_specific_urls?/1)
      assert Feed.block_specific_urls?("https://www.google.com") == false

      assert Feed.block_specific_urls?("https://factcheck-site.com/article-about-amazon-com") ==
               false

      assert Feed.block_specific_urls?("https://facebook.com") == false
    end
  end
end
