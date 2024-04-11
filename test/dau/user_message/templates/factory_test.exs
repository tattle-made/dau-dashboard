defmodule DAU.UserMessage.Templates.FactoryTest do
  alias DAU.UserMessage.Templates.Factory
  alias DAU.Feed.Common
  use DAU.DataCase

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
