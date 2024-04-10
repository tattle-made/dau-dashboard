defmodule DAU.UserMessage.Templates.FactoryTest do
  alias DAU.UserMessage.Templates.Factory
  alias DAU.Feed.Common
  use DAU.DataCase

  describe "response text for all scenarios" do
    test "deepfake_w_ar_0fc" do
      feed_common = %Common{
        verification_status: :deepfake,
        assessment_report: "https://dau.mcaindia.in/blog/dummy-url-of-a-video",
        factcheck_articles: []
      }

      template = Factory.process(feed_common)
      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢 We reviewed this audio/video and found it to be a Deepfake.\n\n🎯You can read our assessment report here: https://dau.mcaindia.in/blog/dummy-url-of-a-video\n\n🧠 Please use your discretion in sharing this information.\n\nThank you for reaching out to us. We hope you have a good day ahead. 🙏"
    end

    test "deepfake_wo_ar_2fc" do
      feed_common =
        %Common{verification_status: :deepfake}
        |> Common.query_with_factcheck_article(%{
          username: "dau_factchecker",
          url: "https://factly.in/article-2"
        })
        |> apply_changes()
        |> Common.query_with_factcheck_article(%{
          username: "dau_factchecker",
          url: "https://www.vishvasnews.com/article-1"
        })
        |> apply_changes()

      template = Factory.process(feed_common)
      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢 We reviewed this audio/video and found it to be a Deepfake.\n\nFact checkers have also shared the following:\n\n1.vishvasnews: https://www.vishvasnews.com/article-1\n\n2.factly: https://factly.in/article-2\n\n🧠 Please use your discretion in sharing this information.\n\nThank you for reaching out to us. We hope you have a good day ahead. 🙏"
    end

    test "manipulated_w_ar_0fc" do
    end

    test "manipulated_wo_ar_1fc" do
    end

    test "manipulated_wo_ar_2fc" do
    end
  end

  describe "undefined template scenario" do
    test "deepfake with assessment report and fact check article" do
      feed_common =
        %Common{
          verification_status: :deepfake,
          assessment_report: "https://dau.mcaindia.in/blog/dummy-url-of-a-video"
        }
        |> Common.query_with_factcheck_article(%{
          username: "dau_factchecker",
          url: "https://factcheck-site.com/article-2"
        })
        |> apply_changes()

      template = Factory.process(feed_common)
      assert template.meta.valid == false

      {:error, reason} = Factory.eval(template)
      assert reason =~ "There is no template file for this configuration."
    end
  end
end
