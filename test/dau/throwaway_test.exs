defmodule DAU.ThrowawayTest do
  use DAU.DataCase
  alias DAU.Feed.Common
  alias DAU.Repo
  alias DAU.UserMessage.Templates.Factory
  alias DAU.Feed.AssessmentReport
  alias DAU.Feed.FactcheckArticle
  # use DAU.ConnCase

  describe "Blacklist Myntra, Flipkart & Amazon links" do
    setup do
      %{}
    end

    def blacklisted_url?(url) do
      keywords = ~r/(amazon|myntra|flipkart|mnatry|flipkin|amznin)/i

      case URI.parse(url) do
        %{host: nil, query: "", path: path} ->
          Regex.match?(keywords, path)

        %{host: nil, query: query} ->
          Regex.match?(keywords, query)

        %{host: domain} ->
          Regex.match?(keywords, domain)

        _ ->
          false
      end
    end

    test "test a" do
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

      assert Enum.all?(urls, &blacklisted_url?/1)
      assert blacklisted_url?("https://www.google.com") == false
      assert blacklisted_url?("https://factcheck-site.com/article-about-amazon-com") == false
      assert blacklisted_url?("https://facebook.com") == false
    end
  end

  describe "Using Media Matching to auto-tag SPAM content" do
    setup do
      common_a =
        %Common{}
        |> Common.changeset(%{
          media_urls: ["https://example.com/video1.mp4"],
          media_type: :video,
          sender_number: "1234567890",
          verification_status: :spam
        })
        |> Repo.insert!()

      common_b =
        %Common{}
        |> Common.changeset(%{
          media_urls: ["https://example.com/video2.mp4"],
          media_type: :video,
          sender_number: "1234567890"
        })
        |> Repo.insert!()

      {:ok, common_a: common_a, common_b: common_b}
    end

    def update_common_verification_status(common_a, common_b) do
      if common_a.verification_status == :spam do
        common_b = Repo.get!(Common, common_b.id)

        common_b
        |> Common.changeset(%{verification_status: :spam})
        |> Repo.update()
      end
    end

    test "test a", state do
      update_common_verification_status(state.common_a, state.common_b)
      updated_common_b = Repo.get(Common, state.common_b.id)
      assert updated_common_b.verification_status == :spam
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

      common_w_label_wo_ar_w_2fc =
        %Common{}
        |> Common.changeset(%{
          media_urls: ["https://example.com/video1.mp4"],
          media_type: :video,
          sender_number: "1234567890",
          verification_status: :deepfake
        })
        |> Common.query_with_updated_factcheck_article_changeset([
          %FactcheckArticle{
            username: "Publisher One",
            url: "https://publisher-one.com/article-1"
          },
          %FactcheckArticle{
            username: "Publisher Two",
            url: "https://publisher-one.com/article-2"
          }
        ])
        |> Repo.insert!()

      {:ok,
       common_wo_label_wo_ar_wo_fc: common_wo_label_wo_ar_wo_fc,
       common_w_label_wo_ar_wo_fc: common_w_label_wo_ar_wo_fc,
       common_w_label_w_ar_wo_fc: common_w_label_w_ar_wo_fc,
       common_w_label_wo_ar_w_2fc: common_w_label_wo_ar_w_2fc}
    end

    test "test a", state do
      proc_common_wo_label_wo_ar_wo_fc = Factory.process(state.common_wo_label_wo_ar_wo_fc)
      assert proc_common_wo_label_wo_ar_wo_fc.meta.valid == false

      proc_common_w_label_wo_ar_wo_fc = Factory.process(state.common_w_label_wo_ar_wo_fc)
      assert proc_common_w_label_wo_ar_wo_fc.meta.valid == false

      proc_common_w_label_w_ar_wo_fc = Factory.process(state.common_w_label_w_ar_wo_fc)
      assert proc_common_w_label_w_ar_wo_fc.meta.valid == true
    end
  end
end
