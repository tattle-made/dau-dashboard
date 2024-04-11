defmodule DAU.UserMessage.Templates.BspToDashboardIntegrationTest do
  use DAU.DataCase

  alias DAU.UserMessage.Templates.Template
  alias DAU.UserMessage.Templates.Factory
  alias DAU.Feed.Common

  describe "data integrity" do
    test "match evaluated template with message in unify portal" do
      # text_copied_from_unify = """
      # 📢 We reviewed this audio/video and found it to be Manipulated.

      # Fact checkers have also shared the following:

      # 1. {{1}}: {{2}}

      # 🧠 Please use your discretion in sharing this information.

      # Thank you for reaching out to us. We hope you have a good day ahead. 🙏
      # """

      # template = %Template{
      #   meta: %{
      #     valid: true,
      #     template_name: "manipulated_wo_ar_1fc",
      #     template_parameters: [
      #       factcheck_articles: [
      #         %{domain: "{{1}}", url: "{{2}}"}
      #       ]
      #     ]
      #   }
      # }

      # template = %Template{
      #   meta: %{
      #     valid: true,
      #     template_name: "manipulated_wo_ar_1fc",
      #     template_parameters: [
      #       factcheck_articles: [
      #         %{domain: "test", url: "google.com"}
      #       ]
      #     ]
      #   }
      # }

      # {:ok, text_evaluated_from_template} = Factory.eval(template)
      # assert text_evaluated_from_template == text_copied_from_unify
    end
  end

  describe "response text for all scenarios" do
    test "deepfake_w_ar_0fc_en" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "deepfake_w_ar_0fc_en",
          template_parameters: [
            assessment_report: "https://dau.mcaindia.com/article-1",
            factcheck_articles: []
          ]
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢 We reviewed this audio/video and found it to be a Deepfake.\n\n🎯You can read our assessment report here: https://dau.mcaindia.com/article-1\n\n🧠 Please use your discretion in sharing this information. \n\nThank you for reaching out to us. We hope you have a good day ahead. 🙏"
    end

    test "deepfake_wo_ar_2fc_en" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "deepfake_wo_ar_2fc_en",
          template_parameters: [
            factcheck_articles: [
              %{domain: "Publisher One", url: "https://publisher-one.com/article-1"},
              %{domain: "Publisher Two", url: "https://publisher-one.com/article-2"}
            ]
          ]
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢 We reviewed this audio/video and found it to be a Deepfake.\n\nFact checkers have also shared the following: \n\n1.Publisher One: https://publisher-one.com/article-1\n\n2. Publisher Two: https://publisher-one.com/article-2\n\n🧠 Please use your discretion in sharing this information. \n\nThank you for reaching out to us. We hope you have a good day ahead. 🙏"
    end

    test "manipulated_wo_ar_1fc_en" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "manipulated_wo_ar_1fc_en",
          template_parameters: [
            factcheck_articles: [
              %{domain: "Publisher One", url: "https://publisher-one.com/article-1"}
            ]
          ]
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢 We reviewed this audio/video and found it to be Manipulated.\n\nFact checkers have also shared the following: \n\n1. Publisher One: https://publisher-one.com/article-1\n\n🧠 Please use your discretion in sharing this information. \n\nThank you for reaching out to us. We hope you have a good day ahead. 🙏"
    end

    test "manipulated_wo_ar_2fc_en" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "manipulated_wo_ar_2fc_en",
          template_parameters: [
            factcheck_articles: [
              %{domain: "Publisher One", url: "https://publisher-one.com/article-1"},
              %{domain: "Publisher Two", url: "https://publisher-two.com/article-1"}
            ]
          ]
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢 We reviewed this audio/video and found it to be Manipulated.\n\nFact checkers have also shared the following: \n\n1. Publisher One: https://publisher-one.com/article-1\n\n2. Publisher Two: https://publisher-two.com/article-1\n\n\n🧠 Please use your discretion in sharing this information. \n\nThank you for reaching out to us. We hope you have a good day ahead. 🙏"
    end

    test "manipulated_w_ar_0fc_en" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "manipulated_w_ar_0fc_en",
          template_parameters: [
            assessment_report: "https:dau.mcaindia.in/assessment-report-1"
          ]
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢 We reviewed this audio/video and found it to be Manipulated.\n\n🎯You can read our assessment report here: https:dau.mcaindia.in/assessment-report-1\n\n🧠 Please use your discretion in sharing this information. \n\nThank you for reaching out to us. We hope you have a good day ahead. 🙏"
    end

    test "not_manipulated_wo_ar_0fc_en" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "not_manipulated_wo_ar_0fc_en",
          template_parameters: []
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢 We reviewed this audio/video and found it to be Not Manipulated.\n\n🧠 Please use your discretion in sharing this information. \n\nThank you for reaching out to us. We hope you have a good day ahead. 🙏"
    end

    test "not_manipulated_wo_ar_1fc_en" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "not_manipulated_wo_ar_1fc_en",
          template_parameters: [
            factcheck_articles: [
              %{domain: "Publisher One", url: "https://publisher-one.com/article-1"}
            ]
          ]
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢 We reviewed this audio/video and found it to be Not Manipulated.\n\nFact checkers have also shared the following: \n\n1. Publisher One:https://publisher-one.com/article-1\n\n🧠 Please use your discretion in sharing this information. \n\nThank you for reaching out to us. We hope you have a good day ahead. 🙏"
    end

    test "not_manipualted_wo_ar_2fc_en" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "not_manipualted_wo_ar_2fc_en",
          template_parameters: [
            factcheck_articles: [
              %{domain: "Publisher One", url: "https://publisher-one.com/article-1"},
              %{domain: "Publisher Two", url: "https://publisher-one.com/article-2"}
            ]
          ]
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢 We reviewed this audio/video and found it to be Not Manipulated.\n\nFact checkers have also shared the following: \n\n1. Publisher One: https://publisher-one.com/article-1\n\n2. Publisher Two: https://publisher-one.com/article-2\n\n🧠 Please use your discretion in sharing this information. \n\nThank you for reaching out to us. We hope you have a good day ahead. 🙏"
    end

    test "inconclusive_w_ar_0fc_en" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "inconclusive_w_ar_0fc_en",
          template_parameters: [
            assessment_report: "https://dau.mcaindia.in/assessment-report-1",
            factcheck_articles: []
          ]
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢 We reviewed this audio/video and found it to be Inconclusive.\n\n🎯You can read our assessment report here: https://dau.mcaindia.in/assessment-report-1\n\n🧠 Please use your discretion in sharing this information. \n\nThank you for reaching out to us. We hope you have a good day ahead. 🙏"
    end

    test "out_of_scope_wo_ar_0fc_en" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "out_of_scope_wo_ar_0fc_en",
          template_parameters: [
            assessment_report: "https://dau.mcaindia.in/assessment-report-1",
            factcheck_articles: []
          ]
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "We appreciate you taking time out to send this audio/video. 🙌\n\nWe only check audio/video that are of public interest and likely to mislead people. We don't review personal and private audio/video.\n\nIf you come across anything that is suspicious or misleading, please do not hesitate to reach out to us again.\n\nWe hope you have a good day ahead. 🙏"
    end

    test "not_ai_generated_wo_ar_0fc_en" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "not_ai_generated_wo_ar_0fc_en",
          template_parameters: []
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢 We didn't find any element of AI generation in this audio/video. But lack of AI-manipulation does not mean that the information provided in the audio/video is accurate.\n\nIf you want to get a fact-check on this audio/video you can share it with other Whatsapp tiplines listed below:\n\n➡️Boom: +91-7700906588\n➡️Vishvas News: +91-9599299372\n➡️Factly: +91-9247052470\n➡️THIP: +91-8507885079\n➡️Newschecker: +91-9999499044\n➡️Fact Crescendo: +91-9049053770\n➡️India Today: +91-7370007000\n➡️Newsmobile:+91-1171279799\n➡️Quint WebQoof: +91-9540511818\n➡️Logically Facts: +91-8640070078\n➡️Newsmeter: +91-7482830440\n\nThank you for reaching out to us. We hope you have a good day ahead. 🙏"
    end

    test "not_ai_generated_wo_ar_1fc_en" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "not_ai_generated_wo_ar_1fc_en",
          template_parameters: [
            factcheck_articles: [
              %{domain: "Publisher One", url: "https://publisher-one.com/article-1"}
            ]
          ]
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢 We didn't find any element of AI generation in this audio/video. But lack of AI-manipulation does not mean that the information provided in the audio/video is accurate. \n\nFact checkers have also shared the following: \n\n1. Publisher One:https://publisher-one.com/article-1\n\n🧠 Please use your discretion in sharing this information. \n\nThank you for reaching out to us. We hope you have a good day ahead. 🙏"
    end

    test "not_ai_generated_wo_ar_2fc_en" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "not_ai_generated_wo_ar_2fc_en",
          template_parameters: [
            factcheck_articles: [
              %{domain: "Publisher One", url: "https://publisher-one.com/article-1"},
              %{domain: "Publisher Two", url: "https://publisher-one.com/article-2"}
            ]
          ]
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢 We didn't find any element of AI generation in this audio/video. But lack of AI-manipulation does not mean that the information provided in the audio/video is accurate.\n\nFact checkers have also shared the following: \n\n1. Publisher One: https://publisher-one.com/article-1\n\n2. Publisher Two: https://publisher-one.com/article-2\n\n🧠 Please use your discretion in sharing this information. \n\nThank you for reaching out to us. We hope you have a good day ahead. 🙏"
    end

    test "unsupported_language_wo_ar_0fc_en" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "unsupported_language_wo_ar_0fc_en",
          template_parameters: [
            factcheck_articles: []
          ]
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "🫣 Oops! The media you shared is in a language we don't currently support. You can share it with other fact checkers on Whatsapp tiplines listed below:\n\n➡️Boom: +91-7700906588\n➡️Vishvas News: +91-9599299372\n➡️Factly: +91-9247052470\n➡️THIP: +91-8507885079\n➡️Newschecker: +91-9999499044\n➡️Fact Crescendo: +91-9049053770\n➡️India Today: +91-7370007000\n➡️Newsmobile:+91-1171279799\n➡️Quint WebQoof: +91-9540511818\n➡️Logically Facts: +91-8640070078\n➡️Newsmeter: +91-7482830440\n\nThank you for reaching out to us. We hope you have a good day ahead. 🙏"
    end

    test "ai_generated_wo_ar_0fc_en" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "ai_generated_wo_ar_0fc_en",
          template_parameters: [
            factcheck_articles: []
          ]
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢 We reviewed this audio/video and found it to be AI-Generated.\n\n🎯While AI has been used in the production of this audio/video but it does not feature harmful content. In this case it seems that AI has been used for a creative purpose.\n\n🧠 Please use your discretion in sharing this information. \n\nThank you for reaching out to us. We hope you have a good day ahead. 🙏"
    end

    test "ai_generated_w_ar_0fc_en" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "ai_generated_w_ar_0fc_en",
          template_parameters: [
            assessment_report: "https://dau.mcaindia.in/assessment-report-01",
            factcheck_articles: []
          ]
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢 We reviewed this audio/video and found it to be AI-Generated.\n\n🎯You can read our assessment report here: https://dau.mcaindia.in/assessment-report-01\n\n🧠 Please use your discretion in sharing this information. \n\nThank you for reaching out to us. We hope you have a good day ahead. 🙏"
    end

    test "ai_generated_wo_ar_1fc_en" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "ai_generated_wo_ar_1fc_en",
          template_parameters: [
            factcheck_articles: [
              %{domain: "Publisher One", url: "https://publisher-one.com/article-1"}
            ]
          ]
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢 We reviewed this audio/video and found it to be AI-Generated.\n\nFact checkers have also shared the following: \n\n1. Publisher One: https://publisher-one.com/article-1\n\n🧠 Please use your discretion in sharing this information. \n\nThank you for reaching out to us. We hope you have a good day ahead. 🙏"
    end

    test "ai_generated_wo_ar_2fc_en" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "ai_generated_wo_ar_2fc_en",
          template_parameters: [
            factcheck_articles: [
              %{domain: "Publisher One", url: "https://publisher-one.com/article-1"},
              %{domain: "Publisher Two", url: "https://publisher-one.com/article-2"}
            ]
          ]
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢 We reviewed this audio/video and found it to be AI-Generated.\n\nFact checkers have also shared the following: \n\n1. Publisher One: https://publisher-one.com/article-1\n\n2.Publisher Two: https://publisher-one.com/article-2\n\n🧠 Please use your discretion in sharing this information. \n\nThank you for reaching out to us. We hope you have a good day ahead. 🙏"
    end
  end
end
