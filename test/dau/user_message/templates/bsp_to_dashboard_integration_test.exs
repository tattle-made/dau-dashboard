defmodule DAU.UserMessage.Templates.BspToDashboardIntegrationTest do
  use DAU.DataCase

  alias DAU.UserMessage.Templates.Template
  alias DAU.UserMessage.Templates.Factory
  alias DAU.Feed.Common

  describe "data integrity" do
    test "check total number of whitelisted templates" do
    end

    test "match evaluated template with message in unify portal" do
      text_copied_from_unify = """
      📢 We reviewed this audio/video and found it to be Manipulated.

      Fact checkers have also shared the following:

      1. {{1}}: {{2}}

      🧠 Please use your discretion in sharing this information.

      Thank you for reaching out to us. We hope you have a good day ahead. 🙏
      """

      template = %Template{
        meta: %{
          valid: true,
          template_name: "manipulated_wo_ar_1fc",
          template_parameters: [
            factcheck_articles: [
              %{domain: "{{1}}", url: "{{2}}"}
            ]
          ]
        }
      }

      template = %Template{
        meta: %{
          valid: true,
          template_name: "manipulated_wo_ar_1fc",
          template_parameters: [
            factcheck_articles: [
              %{domain: "test", url: "google.com"}
            ]
          ]
        }
      }

      {:ok, text_evaluated_from_template} = Factory.eval(template)
      assert text_evaluated_from_template == text_copied_from_unify
    end
  end
end
