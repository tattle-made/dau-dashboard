defmodule DAU.UserMessage.Templates.BspToDashboardIntegrationTest do
  use DAU.DataCase

  alias DAU.UserMessage.Templates.Template
  alias DAU.UserMessage.Templates.Factory

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

    test "not_manipulated_wo_ar_2fc_en" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "not_manipulated_wo_ar_2fc_en",
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

    test "deepfake_w_ar_0fc_hi" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "deepfake_w_ar_0fc_hi",
          language: :hi,
          template_parameters: [
            assessment_report: "https://dau.mcaindia.in/assessment-report-01",
            factcheck_articles: []
          ]
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢 हमनें इस ऑडियो/वीडियो की पड़ताल की और पाया कि यह डीपफेक है. \n\n🎯इस ऑडियो/वीडियो को लेकर हमारी पड़ताल को विस्तार से यहाँ पढ़ सकते हैं: https://dau.mcaindia.in/assessment-report-01\n\n🧠  कृपया अपने सूझ-बूझ का इस्तेमाल कर ही इस जानकारी को शेयर करें.\n\nहमारी सेवाओं का इस्तेमाल करने के लिए धन्यवाद. आपका दिन शुभ हो. 🙏"
    end

    test "deepfake_wo_ar_1fc_hi" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "deepfake_wo_ar_1fc_hi",
          language: :hi,
          template_parameters: [
            factcheck_articles: [
              %{domain: "Publisher One", url: "https://publisher-one.com/article-1"}
            ]
          ]
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢 हमनें इस ऑडियो/वीडियो की पड़ताल की और पाया कि यह डीपफेक है. \n\nफैक्ट चेकर्स ने यह भी शेयर किया है:\n\n1. Publisher One: https://publisher-one.com/article-1\n\n🧠  कृपया अपने सूझ-बूझ का इस्तेमाल कर ही इस जानकारी को शेयर करें.\n\nहमारी सेवाओं का इस्तेमाल करने के लिए धन्यवाद. आपका दिन शुभ हो. 🙏"
    end

    test "deepfake_wo_ar_2fc_hi" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "deepfake_wo_ar_2fc_hi",
          language: :hi,
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
               "📢 हमनें इस ऑडियो/वीडियो की पड़ताल की और पाया कि यह डीपफेक है. \n\nफैक्ट चेकर्स ने यह भी शेयर किया है:\n\n1.Publisher One: https://publisher-one.com/article-1\n\n2. Publisher Two: https://publisher-one.com/article-2\n\n🧠  कृपया अपने सूझ-बूझ का इस्तेमाल कर ही इस जानकारी को शेयर करें.\n\nहमारी सेवाओं का इस्तेमाल करने के लिए धन्यवाद. आपका दिन शुभ हो. 🙏"
    end

    test "manipulated_w_ar_0fc_hi" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "manipulated_w_ar_0fc_hi",
          language: :hi,
          template_parameters: [
            assessment_report: "https:dau.mcaindia.in/assessment-report-1"
          ]
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢 हमनें इस ऑडियो/वीडियो की पड़ताल की और पाया कि इसके साथ छेड़छाड़ की गई है.\n\n🎯इस ऑडियो/वीडियो को लेकर हमारी पड़ताल को विस्तार से यहाँ पढ़ सकते हैं: https:dau.mcaindia.in/assessment-report-1\n\n🧠 कृपया अपने सूझ-बूझ का इस्तेमाल कर ही इस जानकारी को शेयर करें.\n\nहमारी सेवाओं का इस्तेमाल करने के लिए धन्यवाद. आपका दिन शुभ हो. 🙏"
    end

    test "manipulated_wo_ar_1fc_hi" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "manipulated_wo_ar_1fc_hi",
          language: :hi,
          template_parameters: [
            factcheck_articles: [
              %{domain: "Publisher One", url: "https://publisher-one.com/article-1"}
            ]
          ]
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢 हमनें इस ऑडियो/वीडियो की पड़ताल की और पाया कि इसके साथ छेड़छाड़ की गई है.\n\nफैक्ट चेकर्स ने यह भी शेयर किया है:\n\n1. Publisher One: https://publisher-one.com/article-1\n\n🧠 कृपया अपने सूझ-बूझ का इस्तेमाल कर ही इस जानकारी को शेयर करें.\n\nहमारी सेवाओं का इस्तेमाल करने के लिए धन्यवाद. आपका दिन शुभ हो. 🙏"
    end

    test "manipulated_wo_ar_2fc_hi" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "manipulated_wo_ar_2fc_hi",
          language: :hi,
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
               "📢 हमनें इस ऑडियो/वीडियो की पड़ताल की और पाया कि इसके साथ छेड़छाड़ की गई है.\n\nफैक्ट चेकर्स ने यह भी शेयर किया है:\n\n1. Publisher One: https://publisher-one.com/article-1\n\n2. Publisher Two: https://publisher-two.com/article-1\n\n🧠 कृपया अपने सूझ-बूझ का इस्तेमाल कर ही इस जानकारी को शेयर करें.\n\nहमारी सेवाओं का इस्तेमाल करने के लिए धन्यवाद. आपका दिन शुभ हो. 🙏"
    end

    test "not_manipulated_wo_ar_0fc_hi" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "not_manipulated_wo_ar_0fc_hi",
          language: :hi,
          template_parameters: []
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢 हमनें इस ऑडियो/वीडियो की पड़ताल की और पाया कि इसके साथ छेड़छाड़ नहीं की गई है. \n\n🧠  कृपया अपने सूझ-बूझ का इस्तेमाल कर ही इस जानकारी को शेयर करें.\n\nहमारी सेवाओं का इस्तेमाल करने के लिए धन्यवाद. आपका दिन शुभ हो. 🙏"
    end

    test "not_manipulated_wo_ar_1fc_hi" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "not_manipulated_wo_ar_1fc_hi",
          language: :hi,
          template_parameters: [
            factcheck_articles: [
              %{domain: "Publisher One", url: "https://publisher-one.com/article-1"}
            ]
          ]
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢 हमनें इस ऑडियो/वीडियो की पड़ताल की और पाया कि इसके साथ छेड़छाड़ नहीं की गई है. \n\nफैक्ट चेकर्स ने यह भी शेयर किया है:\n\n1. Publisher One:https://publisher-one.com/article-1\n\n🧠  कृपया अपने सूझ-बूझ का इस्तेमाल कर ही इस जानकारी को शेयर करें.\n\nहमारी सेवाओं का इस्तेमाल करने के लिए धन्यवाद. आपका दिन शुभ हो. 🙏"
    end

    test "not_manipulated_wo_ar_2fc_hi" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "not_manipulated_wo_ar_2fc_hi",
          language: :hi,
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
               "📢 हमनें इस ऑडियो/वीडियो की पड़ताल की और पाया कि इसके साथ छेड़छाड़ नहीं की गई है. \n\nफैक्ट चेकर्स ने यह भी शेयर किया है:\n\n1. Publisher One: https://publisher-one.com/article-1\n\n2. Publisher Two: https://publisher-one.com/article-2\n\n🧠कृपया अपने सूझ-बूझ का इस्तेमाल कर ही इस जानकारी को शेयर करें.\n\nहमारी सेवाओं का इस्तेमाल करने के लिए धन्यवाद. आपका दिन शुभ हो. 🙏"
    end

    test "ai_generated_wo_ar_0fc_hi" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "ai_generated_wo_ar_0fc_hi",
          language: :hi,
          template_parameters: []
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢हमनें इस ऑडियो/वीडियो की पड़ताल की और पाया कि यह AI-Generated है. \n\n🎯यह सच है कि इस ऑडियो/वीडियो को बनाने मे AI का इस्तेमाल हुआ है, लेकिन इसका कंटेंट नुकसानदायक नही है. यहां AI का इस्तेमाल रचनात्मकता के उद्देश्य से किया गया है.\n\n🧠  कृपया अपने सूझ-बूझ का इस्तेमाल कर ही इस जानकारी को शेयर करें.\n\nहमारी सेवाओं का इस्तेमाल करने के लिए धन्यवाद. आपका दिन शुभ हो. 🙏"
    end

    test "ai_generated_w_ar_0fc_hi" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "ai_generated_w_ar_0fc_hi",
          language: :hi,
          template_parameters: [
            assessment_report: "https:dau.mcaindia.in/assessment-report-1"
          ]
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢 हमनें इस ऑडियो/वीडियो की पड़ताल की और पाया कि यह AI-Generated है. \n\n🎯इस ऑडियो/वीडियो को लेकर हमारी पड़ताल को विस्तार से यहाँ पढ़ सकते हैं:https:dau.mcaindia.in/assessment-report-1\n\n🧠कृपया अपने सूझ-बूझ का इस्तेमाल कर ही इस जानकारी को शेयर करें.\n\nहमारी सेवाओं का इस्तेमाल करने के लिए धन्यवाद. आपका दिन शुभ हो. 🙏"
    end

    test "ai_generated_wo_ar_1fc_hi" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "ai_generated_wo_ar_1fc_hi",
          language: :hi,
          template_parameters: [
            factcheck_articles: [
              %{domain: "Publisher One", url: "https://publisher-one.com/article-1"}
            ]
          ]
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢 हमनें इस ऑडियो/वीडियो की पड़ताल की और पाया कि यह AI-Generated है.\n\nफैक्ट चेकर्स ने यह भी शेयर किया है:\n\n1. Publisher One: https://publisher-one.com/article-1\n\n🧠  कृपया अपने सूझ-बूझ का इस्तेमाल कर ही इस जानकारी को शेयर करें.\n\nहमारी सेवाओं का इस्तेमाल करने के लिए धन्यवाद. आपका दिन शुभ हो. 🙏"
    end

    test "ai_generated_wo_ar_2fc_hi" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "ai_generated_wo_ar_2fc_hi",
          language: :hi,
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
               "📢 हमनें इस ऑडियो/वीडियो की पड़ताल की और पाया कि यह AI-Generated है. \n\nफैक्ट चेकर्स ने यह भी शेयर किया है: \n\n1. Publisher One: https://publisher-one.com/article-1\n\n2. Publisher Two: https://publisher-one.com/article-2\n\n🧠 कृपया अपने सूझ-बूझ का इस्तेमाल कर ही इस जानकारी को शेयर करें.\n\nहमारी सेवाओं का इस्तेमाल करने के लिए धन्यवाद. आपका दिन शुभ हो. 🙏"
    end

    test "not_ai_generated_wo_ar_0fc_hi" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "not_ai_generated_wo_ar_0fc_hi",
          language: :hi,
          template_parameters: []
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢 हमें इस ऑडियो/वीडियो में AI टूल्स के इस्तेमाल का कोई निशान नहीं मिला. लेकिन इसका यह मतलब नहीं है कि इसमें दी गई सूचना सही है.\n\nआप इस ऑडियो/वीडियो को दूसरे फैक्ट चेकर्स के WhatsApp टिपलाइन्स पर भेज कर इसका सच जान सकते हैं, जिनके नंबर निचे मौजूद हैं:\n\n➡️Boom: +91-7700906588\n➡️Vishvas News: +91-9599299372\n➡️Factly: +91-9247052470\n➡️THIP: +91-8507885079\n➡️Newschecker: +91-9999499044\n➡️Fact Crescendo: +91-9049053770\n➡️India Today: +91-7370007000\n➡️Newsmobile:+91-1171279799\n➡️Quint WebQoof: +91-9540511818\n➡️Logically Facts: +91-8640070078\n➡️Newsmeter: +91-7482830440\n\n🧠 कृपया अपने सूझ-बूझ का इस्तेमाल कर ही इस जानकारी को शेयर करें.\n\nहमारी सेवाओं का इस्तेमाल करने के लिए धन्यवाद. आपका दिन शुभ हो. 🙏"
    end

    test "not_ai_generated_wo_ar_1fc_hi" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "not_ai_generated_wo_ar_1fc_hi",
          language: :hi,
          template_parameters: [
            factcheck_articles: [
              %{domain: "Publisher One", url: "https://publisher-one.com/article-1"}
            ]
          ]
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢 हमें इस ऑडियो/वीडियो में AI टूल्स के इस्तेमाल का कोई निशान नहीं मिला. लेकिन इसका यह मतलब नहीं है कि इसमें दी गई सूचना सही है.\n\nफैक्ट चेकर्स ने यह भी शेयर किया है:\n\n1. Publisher One:https://publisher-one.com/article-1\n\n🧠 कृपया अपने सूझ-बूझ का इस्तेमाल कर ही इस जानकारी को शेयर करें.\n\nहमारी सेवाओं का इस्तेमाल करने के लिए धन्यवाद. आपका दिन शुभ हो. 🙏"
    end

    test "not_ai_generated_wo_ar_2fc_hi" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "not_ai_generated_wo_ar_2fc_hi",
          language: :hi,
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
               "📢 हमें इस ऑडियो/वीडियो में AI टूल्स के इस्तेमाल का कोई निशान नहीं मिला. लेकिन इसका यह मतलब नहीं है कि इसमें दी गई सूचना सही है.\n\nफैक्ट चेकर्स ने यह भी शेयर किया है:\n\n1. Publisher One: https://publisher-one.com/article-1\n\n2. Publisher Two: https://publisher-one.com/article-2\n\n🧠 कृपया अपने सूझ-बूझ का इस्तेमाल कर ही इस जानकारी को शेयर करें.\n\nहमारी सेवाओं का इस्तेमाल करने के लिए धन्यवाद. आपका दिन शुभ हो. 🙏"
    end

    test "inconclusive_w_ar_0fc_hi" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "inconclusive_w_ar_0fc_hi",
          language: :hi,
          template_parameters: [
            assessment_report: "https:dau.mcaindia.in/assessment-report-1"
          ]
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢हमनें इस ऑडियो/वीडियो की पड़ताल की और पाया कि इसे लेकर किसी निर्णायक नतीजे पर नहीं पहुँचा जा सकता.\n\n🎯इस ऑडियो/वीडियो को लेकर हमारी पड़ताल को विस्तार से यहाँ पढ़ सकते हैं: https:dau.mcaindia.in/assessment-report-1\n\n🧠कृपया अपने सूझ-बूझ का इस्तेमाल कर ही इस जानकारी को शेयर करें.\n\nहमारी सेवाओं का इस्तेमाल करने के लिए धन्यवाद. आपका दिन शुभ हो. 🙏"
    end

    test "out_of_scope_wo_ar_0fc_hi" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "out_of_scope_wo_ar_0fc_hi",
          language: :hi,
          template_parameters: []
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "हमें यह ऑडियो/वीडियो नोट भेजने के लिए धन्यवाद. 🙌\n\nहम केवल उन्ही ऑडियो/वीडियो की पड़ताल करते हैं जिनसे समाज में भ्रामक जानकारी फैलने का खतरा हो. हम व्यक्तिगत और निजी ऑडियो/वीडियो की पड़ताल नहीं करते हैं. \n\nअगर आपको कोई ऐसा कंटेंट दिखता है जो भ्रामक या संदिग्ध हो तो कृपया उसे हमें भेजें. \n\nआपका दिन शुभ हो. 🙏"
    end

    test "unsupported_language_wo_ar_0fc_hi" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "unsupported_language_wo_ar_0fc_hi",
          language: :hi,
          template_parameters: []
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "🫣 क्षमा करें, आपके द्वारा भेजी गई मीडिया फाइल एक ऐसी भाषा में है जिसमे हम अभी पड़ताल नहीं करते हैं. आप इस फाइल को दूसरे फैक्ट चेकर्स के WhatsApp टिपलाइन्स पर भेज सकते हैं, जिनके नंबर निचे मौजूद हैं:\n\n➡️Boom: +91-7700906588\n➡️Vishvas News: +91-9599299372\n➡️Factly: +91-9247052470\n➡️THIP: +91-8507885079\n➡️Newschecker: +91-9999499044\n➡️Fact Crescendo: +91-9049053770\n➡️India Today: +91-7370007000\n➡️Newsmobile:+91-1171279799\n➡️Quint WebQoof: +91-9540511818\n➡️Logically Facts: +91-8640070078\n➡️Newsmeter: +91-7482830440\n\nहमारी सेवाओं का इस्तेमाल करने के लिए धन्यवाद. आपका दिन शुभ हो. 🙏"
    end

    test "deepfake_w_ar_0fc_ta" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "deepfake_w_ar_0fc_ta",
          language: :ta,
          template_parameters: [
            assessment_report: "https://dau.mcaindia.in/assessment-report-01",
            factcheck_articles: []
          ]
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢 இந்த audio/video-ஐ நாங்கள் ஆராய்ந்து கண்டறிந்தது என்னவென்றால் அது ஒரு Deepfake ஆகும்.\n\n🎯எங்களுடைய ஆய்வு முடிவுகளை இங்கே படியுங்கள்:https://dau.mcaindia.in/assessment-report-01\n\n🧠 இந்த தகவலைப் பகிரும்முன் கவனமுடன் யோசியுங்கள்.\n\nஎங்களைத் தொடர்பு கொண்டதற்கு நன்றி. இந்த நாள் இனிய நாளாக அமையட்டும் 🙏"
    end

    test "deepfake_wo_ar_1fc_ta" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "deepfake_wo_ar_1fc_ta",
          language: :ta,
          template_parameters: [
            factcheck_articles: [
              %{domain: "Publisher One", url: "https://publisher-one.com/article-1"}
            ]
          ]
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢 இந்த audio/video-ஐ நாங்கள் ஆராய்ந்து கண்டறிந்தது என்னவென்றால் அது ஒரு Deepfake ஆகும்.\n\nஃபேக்ட் செக்கர்களும் இதுகுறித்து கீழ்கண்டவற்றை பகிர்ந்துள்ளனர்:\n\n1. Publisher One: https://publisher-one.com/article-1\n\n🧠 இந்த தகவலைப் பகிரும்முன் கவனமுடன் யோசியுங்கள்.\n\nஎங்களைத் தொடர்பு கொண்டதற்கு நன்றி. இந்த நாள் இனிய நாளாக அமையட்டும் 🙏"
    end

    test "deepfake_wo_ar_2fc_ta" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "deepfake_wo_ar_2fc_ta",
          language: :ta,
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
               "📢 இந்த audio/video-ஐ நாங்கள் ஆராய்ந்து கண்டறிந்தது என்னவென்றால் அது ஒரு Deepfake ஆகும்.\n\nஃபேக்ட் செக்கர்களும் இதுகுறித்து கீழ்கண்டவற்றை பகிர்ந்துள்ளனர்:\n\n1.Publisher One: https://publisher-one.com/article-1\n\n2. Publisher Two: https://publisher-one.com/article-2\n\n🧠 இந்த தகவலைப் பகிரும்முன் கவனமுடன் யோசியுங்கள்.\n\nஎங்களைத் தொடர்பு கொண்டதற்கு நன்றி. இந்த நாள் இனிய நாளாக அமையட்டும் 🙏"
    end

    test "manipulated_w_ar_0fc_ta" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "manipulated_w_ar_0fc_ta",
          language: :ta,
          template_parameters: [
            assessment_report: "https://dau.mcaindia.in/assessment-report-01",
            factcheck_articles: []
          ]
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢 இந்த audio/video-ஐ  நாங்கள் ஆராய்ந்து கண்டறிந்தது என்னவென்றால் சித்தரிக்கப்பட்டதாகும்.\n\n🎯எங்களுடைய ஆய்வு முடிவுகளை இங்கே படியுங்கள்:https://dau.mcaindia.in/assessment-report-01\n\n🧠இந்த தகவலைப் பகிரும்முன் கவனமுடன் யோசியுங்கள்.\n\nஎங்களைத் தொடர்பு கொண்டதற்கு நன்றி. இந்த நாள் இனிய நாளாக அமையட்டும் 🙏"
    end

    test "manipulated_wo_ar_1fc_ta" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "manipulated_wo_ar_1fc_ta",
          language: :ta,
          template_parameters: [
            factcheck_articles: [
              %{domain: "Publisher One", url: "https://publisher-one.com/article-1"}
            ]
          ]
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢 இந்த audio/video-ஐ  நாங்கள் ஆராய்ந்து கண்டறிந்தது என்னவென்றால் \nசித்தரிக்கப்பட்டதாகும்.\n\nஃபேக்ட் செக்கர்களும் இதுகுறித்து கீழ்கண்டவற்றை பகிர்ந்துள்ளனர்:\n\n1. Publisher One: https://publisher-one.com/article-1\n\n🧠இந்த தகவலைப் பகிரும்முன் கவனமுடன் யோசியுங்கள்.\n\nஎங்களைத் தொடர்பு கொண்டதற்கு நன்றி. இந்த நாள் இனிய நாளாக அமையட்டும் 🙏"
    end

    test "manipulated_wo_ar_2fc_ta" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "deepfake_wo_ar_2fc_ta",
          language: :ta,
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
               "📢 இந்த audio/video-ஐ நாங்கள் ஆராய்ந்து கண்டறிந்தது என்னவென்றால் அது ஒரு Deepfake ஆகும்.\n\nஃபேக்ட் செக்கர்களும் இதுகுறித்து கீழ்கண்டவற்றை பகிர்ந்துள்ளனர்:\n\n1.Publisher One: https://publisher-one.com/article-1\n\n2. Publisher Two: https://publisher-one.com/article-2\n\n🧠 இந்த தகவலைப் பகிரும்முன் கவனமுடன் யோசியுங்கள்.\n\nஎங்களைத் தொடர்பு கொண்டதற்கு நன்றி. இந்த நாள் இனிய நாளாக அமையட்டும் 🙏"
    end

    test "not_manipulated_wo_ar_0fc_ta" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "not_manipulated_wo_ar_0fc_ta",
          language: :ta,
          template_parameters: []
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢 இந்த audio/video-ஐ நாங்கள் ஆராய்ந்து கண்டறிந்தது என்னவென்றால் அது சித்தரிக்கப்பட்டதல்ல. \n\n🧠  இந்த தகவலைப் பகிரும்முன் கவனமுடன் யோசியுங்கள்.\n\nஎங்களைத் தொடர்பு கொண்டதற்கு நன்றி. இந்த நாள் இனிய நாளாக அமையட்டும் 🙏"
    end

    test "not_manipulated_wo_ar_1fc_ta" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "not_manipulated_wo_ar_1fc_ta",
          language: :ta,
          template_parameters: [
            factcheck_articles: [
              %{domain: "Publisher One", url: "https://publisher-one.com/article-1"}
            ]
          ]
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢 இந்த audio/video-ஐ நாங்கள் ஆராய்ந்து கண்டறிந்தது என்னவென்றால் அது சித்தரிக்கப்பட்டதல்ல.\n\nஃபேக்ட் செக்கர்களும் இதுகுறித்து கீழ்கண்டவற்றை பகிர்ந்துள்ளனர்:\n\n1. Publisher One:https://publisher-one.com/article-1\n\n🧠இந்த தகவலைப் பகிரும்முன் கவனமுடன் யோசியுங்கள்.\n\nஎங்களைத் தொடர்பு கொண்டதற்கு நன்றி. இந்த நாள் இனிய நாளாக அமையட்டும் 🙏"
    end

    test "not_manipulated_wo_ar_2fc_ta" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "not_manipulated_wo_ar_2fc_ta",
          language: :ta,
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
               "📢 இந்த audio/video-ஐ நாங்கள் ஆராய்ந்து கண்டறிந்தது என்னவென்றால் அது சித்தரிக்கப்பட்டதல்ல.\n\nஃபேக்ட் செக்கர்களும் இதுகுறித்து கீழ்கண்டவற்றை பகிர்ந்துள்ளனர்:\n\n1. Publisher One: https://publisher-one.com/article-1\n\n2. Publisher Two: https://publisher-one.com/article-2\n\n🧠இந்த தகவலைப் பகிரும்முன் கவனமுடன் யோசியுங்கள்.\n\nஎங்களைத் தொடர்பு கொண்டதற்கு நன்றி. இந்த நாள் இனிய நாளாக அமையட்டும் 🙏"
    end

    test "ai_generated_wo_ar_0fc_ta" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "ai_generated_wo_ar_0fc_ta",
          language: :ta,
          template_parameters: []
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢இந்த Audio/Video-வை ஆய்வு செய்து நாங்கள் இது ஒரு AI-Generated. என்பதைக் கண்டறிந்துள்ளோம். \n\n🎯 இந்த audio/video AI மூலமாக உருவாக்கப்பட்டிருந்தாலும் இதில் தீங்கு விளைவிக்கும் வகையிலான உள்ளடக்கம் எதுவும் இல்லை. புதிய படைப்பு உருவாக்கும் நோக்கில் மட்டுமே AI பயன்படுத்தப்பட்டுள்ளது. \n\n🧠உங்களுடைய விருப்பத்தின் அடிப்படையில் இதை பகிர்வது குறித்து முடிவு செய்யுங்கள்.\n\nஎங்களைத் தொடர்பு கொண்டதற்கு நன்றி. இந்த நாள் இனிய நாளாக அமையட்டும். 🙏"
    end

    test "ai_generated_w_ar_0fc_ta" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "ai_generated_w_ar_0fc_ta",
          language: :ta,
          template_parameters: [
            assessment_report: "https://dau.mcaindia.in/assessment-report-01",
            factcheck_articles: []
          ]
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢இந்த audio/video-ஐ நாங்கள் ஆராய்ந்து கண்டறிந்தது என்னவென்றால் அது ஒரு AI-Generated ஆகும்.\n\n🎯எங்களுடைய ஆய்வு முடிவுகளை இங்கே படியுங்கள்: https://dau.mcaindia.in/assessment-report-01\n\n🧠இந்த தகவலைப் பகிரும்முன் கவனமுடன் யோசியுங்கள்.\n\nஎங்களைத் தொடர்பு கொண்டதற்கு நன்றி. இந்த நாள் இனிய நாளாக அமையட்டும் 🙏"
    end

    test "ai_generated_wo_ar_1fc_ta" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "ai_generated_wo_ar_1fc_ta",
          language: :ta,
          template_parameters: [
            factcheck_articles: [
              %{domain: "Publisher One", url: "https://publisher-one.com/article-1"}
            ]
          ]
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢 இந்த audio/video-ஐ நாங்கள் ஆராய்ந்து கண்டறிந்தது என்னவென்றால் அது ஒரு AI-Generated ஆகும்.\n\nஃபேக்ட் செக்கர்களும் இதுகுறித்து கீழ்கண்டவற்றை பகிர்ந்துள்ளனர்:\n\n1. Publisher One: https://publisher-one.com/article-1\n\n🧠இந்த தகவலைப் பகிரும்முன் கவனமுடன் யோசியுங்கள்.\n\nஎங்களைத் தொடர்பு கொண்டதற்கு நன்றி. இந்த நாள் இனிய நாளாக அமையட்டும் 🙏"
    end

    test "ai_generated_wo_ar_2fc_ta" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "ai_generated_wo_ar_2fc_ta",
          language: :ta,
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
               "📢 இந்த audio/video-ஐ நாங்கள் ஆராய்ந்து கண்டறிந்தது என்னவென்றால் அது ஒரு AI-Generated ஆகும்.\n\nஃபேக்ட் செக்கர்களும் இதுகுறித்து கீழ்கண்டவற்றை பகிர்ந்துள்ளனர்:\n\n1. Publisher One: https://publisher-one.com/article-1\n\n2. Publisher Two: https://publisher-one.com/article-2\n\n🧠இந்த தகவலைப் பகிரும்முன் கவனமுடன் யோசியுங்கள்.\n\nஎங்களைத் தொடர்பு கொண்டதற்கு நன்றி. இந்த நாள் இனிய நாளாக அமையட்டும் 🙏"
    end

    test "not_ai_generated_wo_ar_0fc_ta" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "not_ai_generated_wo_ar_0fc_ta",
          language: :ta,
          template_parameters: []
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢 AI தொடர்பான எந்தவொரு உருவாக்கமும் இந்த audio/video-இல்  இல்லை. எனினும், AI தொடர்பான உருவாக்கங்கள் இல்லாமல் இருப்பதால் மட்டும் இந்த audio/video தகவல் உண்மையாக இருக்க வேண்டும் என்பதற்கு எந்தவித உறுதியும் இல்லை.\n\nஇந்த audio/video குறித்த ஃபேக்ட் செக்கினை பெற இதனை மற்ற வாட்ஸப் டிப்லைன் எண்களுடன் பகிருங்கள்.\n\n➡️Boom: +91-7700906588\n➡️Vishvas News: +91-9599299372\n➡️Factly: +91-9247052470\n➡️THIP: +91-8507885079\n➡️Newschecker: +91-9999499044\n➡️Fact Crescendo: +91-9049053770\n➡️India Today: +91-7370007000\n➡️Newsmobile:+91-1171279799\n➡️Quint WebQoof: +91-9540511818\n➡️Logically Facts: +91-8640070078\n➡️Newsmeter: +91-7482830440\n\n🧠இந்த தகவலைப் பகிரும்முன் கவனமுடன் யோசியுங்கள்.\n\nஎங்களைத் தொடர்பு கொண்டதற்கு நன்றி. இந்த நாள் இனிய நாளாக அமையட்டும்   🙏"
    end

    test "not_ai_generated_wo_ar_1fc_ta" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "not_ai_generated_wo_ar_1fc_ta",
          language: :ta,
          template_parameters: [
            factcheck_articles: [
              %{domain: "Publisher One", url: "https://publisher-one.com/article-1"}
            ]
          ]
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢 AI தொடர்பான எந்தவொரு உருவாக்கமும் இந்த audio/video-இல்  இல்லை. எனினும், AI தொடர்பான உருவாக்கங்கள் இல்லாமல் இருப்பதால் மட்டும் இந்த audio/video தகவல் உண்மையாக இருக்க வேண்டும் என்பதற்கு எந்தவித உறுதியும் இல்லை.\n\nஃபேக்ட் செக்கர்களும் இதுகுறித்து கீழ்கண்டவற்றை பகிர்ந்துள்ளனர்:\n\n1. Publisher One:https://publisher-one.com/article-1\n\n🧠இந்த தகவலைப் பகிரும்முன் கவனமுடன் யோசியுங்கள்.\n\nஎங்களைத் தொடர்பு கொண்டதற்கு நன்றி. இந்த நாள் இனிய நாளாக அமையட்டும்   🙏"
    end

    test "not_ai_generated_wo_ar_2fc_ta" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "not_ai_generated_wo_ar_2fc_ta",
          language: :ta,
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
               "📢 AI தொடர்பான எந்தவொரு உருவாக்கமும் இந்த audio/video-இல்  இல்லை. எனினும், AI தொடர்பான உருவாக்கங்கள் இல்லாமல் இருப்பதால் மட்டும் இந்த audio/video தகவல் உண்மையாக இருக்க வேண்டும் என்பதற்கு எந்தவித உறுதியும் இல்லை.\n\nஃபேக்ட் செக்கர்களும் இதுகுறித்து கீழ்கண்டவற்றை பகிர்ந்துள்ளனர்:\n\n1. Publisher One: https://publisher-one.com/article-1\n\n2. Publisher Two: https://publisher-one.com/article-2\n\n🧠இந்த தகவலைப் பகிரும்முன் கவனமுடன் யோசியுங்கள்.\n\nஎங்களைத் தொடர்பு கொண்டதற்கு நன்றி. இந்த நாள் இனிய நாளாக அமையட்டும்   🙏"
    end

    test "inconclusive_w_ar_0fc_ta" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "inconclusive_w_ar_0fc_ta",
          language: :ta,
          template_parameters: [
            assessment_report: "https://dau.mcaindia.in/assessment-report-01",
            factcheck_articles: []
          ]
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢 இந்த audio/video-ஐ நாங்கள் ஆராய்ந்து கண்டறிந்தது என்னவென்றால் அது முடிவற்றது ஆகும்.\n\n🎯எங்களுடைய ஆய்வு முடிவுகளை இங்கே படியுங்கள்: https://dau.mcaindia.in/assessment-report-01\n\n🧠 இந்த தகவலைப் பகிரும்முன் கவனமுடன் யோசியுங்கள்.\n\nஎங்களைத் தொடர்பு கொண்டதற்கு நன்றி. இந்த நாள் இனிய நாளாக அமையட்டும் 🙏"
    end

    test "out_of_scope_wo_ar_0fc_ta" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "out_of_scope_wo_ar_0fc_ta",
          language: :ta,
          template_parameters: []
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "இந்த audio/video-ஐ எங்களுடன் பகிரும் உங்கள் முயற்சியை நாங்கள் பாராட்டுகிறோம். 🙌\n\nநாங்கள் மக்களை ஏமாற்றும் வகையிலான பொதுவான audio/video-ஐ மட்டுமே ஆய்வு செய்வோம். தனிப்பட்ட மற்றும் அந்தரங்க audio/video-ஐ நாங்கள் ஆய்வு செய்வதில்லை.\n\nசந்தேகத்திற்கிடமான வகையில் நீங்கள் எந்த தகவலைக் கடக்க நேர்ந்தாலும் அதனை பகிர்ந்து கொள்ள தயங்க வேண்டாம்.\n\nஇந்த நாள் இனிய நாளாக அமையட்டும் 🙏"
    end

    test "unsupported_language_wo_ar_0fc_ta" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "unsupported_language_wo_ar_0fc_ta",
          language: :ta,
          template_parameters: []
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "🫣 மன்னிக்கவும்! நீங்கள் அனுப்பிய மொழியில் உள்ள மீடியாவை எங்களால் தற்போது பரிசோதிக்க இயலாது. எங்களுடைய மற்ற ஃபேக் செக்கர்களின் வாட்ஸப் டிப்லைனுக்கு உங்களுடைய மீடியாவை அனுப்பி பரிசோதித்துக்கொள்ளுங்கள்.\n\n➡️Boom: +91-7700906588\n➡️Vishvas News: +91-9599299372\n➡️Factly: +91-9247052470\n➡️THIP: +91-8507885079\n➡️Newschecker: +91-9999499044\n➡️Fact Crescendo: +91-9049053770\n➡️India Today: +91-7370007000\n➡️Newsmobile:+91-1171279799\n➡️Quint WebQoof: +91-9540511818\n➡️Logically Facts: +91-8640070078\n➡️Newsmeter: +91-7482830440\n\nஎங்களைத் தொடர்பு கொண்டமைக்கு நன்றி 🙏"
    end

    test "deepfake_w_ar_0fc_te" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "deepfake_w_ar_0fc_te",
          language: :te,
          template_parameters: [
            assessment_report: "https://dau.mcaindia.in/assessment-report-01",
            factcheck_articles: []
          ]
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢 మేము ఈ ఆడియో/వీడియోని రివ్యూ చేసి ఇది డీప్‌ఫేక్ అని నిర్ధారించాము.  \n\n🎯మీరు మా అసెస్మెంట్ రిపోర్ట్ ని ఇక్కడ చదవవచ్చు: https://dau.mcaindia.in/assessment-report-01\n\n🧠 దయచేసి ఈ సమాచారాన్ని షేర్ చేయడానికి మీ విచక్షణను ఉపయోగించండి.\n\nమమ్మల్ని సంప్రదించినందుకు ధన్యవాదాలు. 🙏"
    end

    test "deepfake_wo_ar_1fc_te" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "deepfake_wo_ar_1fc_te",
          language: :te,
          template_parameters: [
            factcheck_articles: [
              %{domain: "Publisher One", url: "https://publisher-one.com/article-1"}
            ]
          ]
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢 మేము ఈ ఆడియో/వీడియోని రివ్యూ చేసి ఇది డీప్‌ఫేక్ అని నిర్ధారించాము.  \n\nఫాక్ట్ చెక్కర్స్ పబ్లిష్ చేసిన ఆర్టికల్స్ కింద చూడవొచ్చు:\n\n1. Publisher One: https://publisher-one.com/article-1\n\n🧠 దయచేసి ఈ సమాచారాన్ని షేర్ చేయడానికి మీ విచక్షణను ఉపయోగించండి.\n\nమమ్మల్ని సంప్రదించినందుకు ధన్యవాదాలు. 🙏"
    end

    test "deepfake_wo_ar_2fc_te" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "deepfake_wo_ar_2fc_te",
          language: :te,
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
               "📢 మేము ఈ ఆడియో/వీడియోని రివ్యూ చేసి ఇది డీప్‌ఫేక్ అని నిర్ధారించాము.  \n\nఫాక్ట్ చెక్కర్స్ పబ్లిష్ చేసిన ఆర్టికల్స్ కింద చూడవొచ్చు:\n\n1.Publisher One: https://publisher-one.com/article-1\n\n2. Publisher Two: https://publisher-one.com/article-2\n\n🧠దయచేసి ఈ సమాచారాన్ని షేర్ చేయడానికి మీ విచక్షణను ఉపయోగించండి.\n\nమమ్మల్ని సంప్రదించినందుకు ధన్యవాదాలు.🙏"
    end

    test "manipulated_w_ar_0fc_te" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "manipulated_w_ar_0fc_te",
          language: :te,
          template_parameters: [
            assessment_report: "https://dau.mcaindia.in/assessment-report-01",
            factcheck_articles: []
          ]
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢 మేము ఈ ఆడియో/వీడియోని రివ్యూ చేసి ఇది మానిప్యులేట్ అయినట్టు నిర్ధారించాము.  \n\n🎯మీరు మా అసెస్మెంట్ రిపోర్ట్ ని ఇక్కడ చదవవచ్చు:https://dau.mcaindia.in/assessment-report-01\n\n🧠దయచేసి ఈ సమాచారాన్ని షేర్ చేయడానికి మీ విచక్షణను ఉపయోగించండి.\n\nమమ్మల్ని సంప్రదించినందుకు ధన్యవాదాలు. 🙏"
    end

    test "manipulated_wo_ar_1fc_te" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "manipulated_wo_ar_1fc_te",
          language: :te,
          template_parameters: [
            factcheck_articles: [
              %{domain: "Publisher One", url: "https://publisher-one.com/article-1"}
            ]
          ]
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢 మేము ఈ ఆడియో/వీడియోని రివ్యూ చేసి ఇది మానిప్యులేట్ అయినట్టు నిర్ధారించాము.  \n\nఫాక్ట్ చెక్కర్స్ పబ్లిష్ చేసిన ఆర్టికల్స్ కింద చూడవొచ్చు:\n\n1. Publisher One: https://publisher-one.com/article-1\n\n🧠దయచేసి ఈ సమాచారాన్ని షేర్ చేయడానికి మీ విచక్షణను ఉపయోగించండి.\n\nమమ్మల్ని సంప్రదించినందుకు ధన్యవాదాలు. 🙏"
    end

    test "manipulated_wo_ar_2fc_te" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "manipulated_wo_ar_2fc_te",
          language: :te,
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
               "📢మేము ఈ ఆడియో/వీడియోని రివ్యూ చేసి ఇది మానిప్యులేట్ అయినట్టు నిర్ధారించాము.  \n\nఫాక్ట్ చెక్కర్స్ పబ్లిష్ చేసిన ఆర్టికల్స్ కింద చూడవొచ్చు:\n\n1. Publisher One: https://publisher-one.com/article-1\n\n2. Publisher Two: https://publisher-one.com/article-2\n\n🧠దయచేసి ఈ సమాచారాన్ని షేర్ చేయడానికి మీ విచక్షణను ఉపయోగించండి.\n\nమమ్మల్ని సంప్రదించినందుకు ధన్యవాదాలు. 🙏"
    end

    test "not_manipulated_wo_ar_0fc_te" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "not_manipulated_wo_ar_0fc_te",
          language: :te,
          template_parameters: []
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢 మేము ఈ ఆడియో/వీడియోని రివ్యూ చేసి ఇది మానిప్యులేట్ అవ్వనట్టు నిర్ధారించాము.  \n\n🧠దయచేసి ఈ సమాచారాన్ని షేర్ చేయడానికి మీ విచక్షణను ఉపయోగించండి.\n\n మమ్మల్ని సంప్రదించినందుకు ధన్యవాదాలు. 🙏"
    end

    test "not_manipulated_wo_ar_1fc_te" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "not_manipulated_wo_ar_1fc_te",
          language: :te,
          template_parameters: [
            factcheck_articles: [
              %{domain: "Publisher One", url: "https://publisher-one.com/article-1"}
            ]
          ]
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢మేము ఈ ఆడియో/వీడియోని రివ్యూ చేసి ఇది మానిప్యులేట్ అవ్వనట్టు నిర్ధారించాము.  \n\nఫాక్ట్ చెక్కర్స్ పబ్లిష్ చేసిన ఆర్టికల్స్ కింద చూడవొచ్చు:\n\n1. Publisher One:https://publisher-one.com/article-1\n\n🧠దయచేసి ఈ సమాచారాన్ని షేర్ చేయడానికి మీ విచక్షణను ఉపయోగించండి.\n \nమమ్మల్ని సంప్రదించినందుకు ధన్యవాదాలు. 🙏"
    end

    test "not_manipulated_wo_ar_2fc_te" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "not_manipulated_wo_ar_2fc_te",
          language: :te,
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
               "📢 మేము ఈ ఆడియో/వీడియోని రివ్యూ చేసి ఇది మానిప్యులేట్ అవ్వనట్టు నిర్ధారించాము.  \n\nఫాక్ట్ చెక్కర్స్ పబ్లిష్ చేసిన ఆర్టికల్స్ కింద చూడవొచ్చు:\n\n1. Publisher One: https://publisher-one.com/article-1\n\n2. Publisher Two: https://publisher-one.com/article-2\n\n🧠దయచేసి ఈ సమాచారాన్ని షేర్ చేయడానికి మీ విచక్షణను ఉపయోగించండి.\n\n మమ్మల్ని సంప్రదించినందుకు ధన్యవాదాలు. 🙏"
    end

    test "ai_generated_wo_ar_0fc_te" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "ai_generated_wo_ar_0fc_te",
          language: :te,
          template_parameters: []
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢ఈ ఆడియో/వీడియోని మేము రివ్యూ చేసి ఇది AI-Generated అని నిర్ధారించాము.\n\n🎯ఈ ఆడియో/వీడియోని తయారు చేయడానికి AI వాడినా, ఇందులో ఏ హానికరమైన సమాచారం లేదు. ఈ సందర్భంలో AI ని సృజనాత్మక ప్రయోజనం కోసమే ఉపయోగించారు. \n\n🧠 ఈ సమాచారాన్ని షేర్ చేయడానికి మీ విచక్షణను ఉపయోగించండి.\n\nమమ్మల్ని సంప్రదించినందుకు ధన్యవాదాలు. 🙏"
    end

    test "ai_generated_w_ar_0fc_te" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "ai_generated_w_ar_0fc_te",
          language: :te,
          template_parameters: [
            assessment_report: "https://dau.mcaindia.in/assessment-report-01",
            factcheck_articles: []
          ]
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢 ఈ ఆడియో/వీడియోని మేము రివ్యూ చేసి ఇది AI-Generated అని నిర్ధారించాము.\n\n🎯మీరు మా అసెస్మెంట్ రిపోర్ట్ ని ఇక్కడ చదవవచ్చు: https://dau.mcaindia.in/assessment-report-01\n\n🧠  దయచేసి ఈ సమాచారాన్ని షేర్ చేయడానికి మీ విచక్షణను ఉపయోగించండి.\n \nమమ్మల్ని సంప్రదించినందుకు ధన్యవాదాలు. 🙏"
    end

    test "ai_generated_wo_ar_1fc_te" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "ai_generated_wo_ar_1fc_te",
          language: :te,
          template_parameters: [
            factcheck_articles: [
              %{domain: "Publisher One", url: "https://publisher-one.com/article-1"}
            ]
          ]
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢 ఈ ఆడియో/వీడియోని మేము రివ్యూ చేసి ఇది AI-Generated అని నిర్ధారించాము.\n\nఫాక్ట్ చెక్కర్స్ పబ్లిష్ చేసిన ఆర్టికల్స్ కింద చూడవొచ్చు:\n\n1. Publisher One: https://publisher-one.com/article-1\n\n🧠దయచేసి ఈ సమాచారాన్ని షేర్ చేయడానికి మీ విచక్షణను ఉపయోగించండి.\n\nమమ్మల్ని సంప్రదించినందుకు ధన్యవాదాలు. 🙏"
    end

    test "ai_generated_wo_ar_2fc_te" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "ai_generated_wo_ar_2fc_te",
          language: :te,
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
               "📢 ఈ ఆడియో/వీడియోని మేము రివ్యూ చేసి ఇది AI-Generated అని నిర్ధారించాము.\n\nఫాక్ట్ చెక్కర్స్ పబ్లిష్ చేసిన ఆర్టికల్స్ కింద చూడవొచ్చు:\n\n1. Publisher One: https://publisher-one.com/article-1\n\n2.Publisher Two: https://publisher-one.com/article-2\n\n🧠దయచేసి ఈ సమాచారాన్ని షేర్ చేయడానికి మీ విచక్షణను ఉపయోగించండి.\n\nమమ్మల్ని సంప్రదించినందుకు ధన్యవాదాలు. 🙏"
    end

    test "not_ai_generated_wo_ar_0fc_te" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "not_ai_generated_wo_ar_0fc_te",
          language: :te,
          template_parameters: []
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢ఈ ఆడియో/వీడియోని AI ఉపయోగించి రూపొందించినట్టు మాకు ఎటువంటి ఆధారాలు లభించలేదు. కానీ ఒక ఆడియో/వీడియో AI ద్వారా మానిప్యులేట్ కానంత మాత్రాన ఆ ఆడియో/వీడియోలోని సమాచారం నిజం అని అర్ధం కాదు.\n\nఈ ఆడియో/వీడియో నిజమో కాదో తెలుసుకోవాలనుకుంటే కింద లిస్ట్ లో ఉన్న ఇతర ఫాక్ట్ చెకర్స్  వాట్సాప్ టిప్ లైన్ ని సంప్రదించండి:\n\n➡️Boom: +91-7700906588\n➡️Vishvas News: +91-9599299372\n➡️Factly: +91-9247052470\n➡️THIP: +91-8507885079\n➡️Newschecker: +91-9999499044\n➡️Fact Crescendo: +91-9049053770\n➡️India Today: +91-7370007000\n➡️Newsmobile:+91-1171279799\n➡️Quint WebQoof: +91-9540511818\n➡️Logically Facts: +91-8640070078\n➡️Newsmeter: +91-7482830440\n\n🧠దయచేసి ఈ సమాచారాన్ని షేర్ చేయడానికి మీ విచక్షణను ఉపయోగించండి.\n\nమమ్మల్ని సంప్రదించినందుకు ధన్యవాదాలు.🙏"
    end

    test "not_ai_generated_wo_ar_1fc_te" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "not_ai_generated_wo_ar_1fc_te",
          language: :te,
          template_parameters: [
            factcheck_articles: [
              %{domain: "Publisher One", url: "https://publisher-one.com/article-1"}
            ]
          ]
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢ఈ ఆడియో/వీడియోని AI ఉపయోగించి రూపొందించినట్టు మాకు ఎటువంటి ఆధారాలు లభించలేదు. కానీ ఒక ఆడియో/వీడియో AI ద్వారా మానిప్యులేట్ కానంత మాత్రాన ఆ ఆడియో/వీడియోలోని సమాచారం నిజం అని అర్ధం కాదు.\n\nఫాక్ట్ చెక్కర్స్ పబ్లిష్ చేసిన ఆర్టికల్స్ కింద చూడవొచ్చు:\n\n1. Publisher One:https://publisher-one.com/article-1\n\n🧠 దయచేసి ఈ సమాచారాన్ని షేర్ చేయడానికి మీ విచక్షణను ఉపయోగించండి.\n\nమమ్మల్ని సంప్రదించినందుకు ధన్యవాదాలు. 🙏"
    end

    test "not_ai_generated_wo_ar_2fc_te" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "not_ai_generated_wo_ar_2fc_te",
          language: :te,
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
               "📢ఈ ఆడియో/వీడియోని AI ఉపయోగించి రూపొందించినట్టు మాకు ఎటువంటి ఆధారాలు లభించలేదు. కానీ ఒక ఆడియో/వీడియో AI ద్వారా మానిప్యులేట్ కానంత మాత్రాన ఆ ఆడియో/వీడియోలోని సమాచారం నిజం అని అర్ధం కాదు.\n\nఫాక్ట్ చెక్కర్స్ పబ్లిష్ చేసిన ఆర్టికల్స్ కింద చూడవొచ్చు:\n\n1. Publisher One: https://publisher-one.com/article-1\n\n2. Publisher Two: https://publisher-one.com/article-2\n\n🧠దయచేసి ఈ సమాచారాన్ని షేర్ చేయడానికి మీ విచక్షణను ఉపయోగించండి.\n\nమమ్మల్ని సంప్రదించినందుకు ధన్యవాదాలు. 🙏"
    end

    test "inconclusive_w_ar_0fc_te" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "inconclusive_w_ar_0fc_te",
          language: :te,
          template_parameters: [
            assessment_report: "https://dau.mcaindia.in/assessment-report-01",
            factcheck_articles: []
          ]
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "📢 మేము ఈ ఆడియో/వీడియోని రివ్యూ చేసి ఓక కచ్చితమయిన నిర్ధారణకు రాలేక పోయాము.  \n\n🎯మీరు మా అసెస్మెంట్ రిపోర్ట్ ని ఇక్కడ చదవవచ్చు: https://dau.mcaindia.in/assessment-report-01\n\n🧠దయచేసి ఈ సమాచారాన్ని షేర్ చేయడానికి మీ విచక్షణను ఉపయోగించండి.\n\nమమ్మల్ని సంప్రదించినందుకు ధన్యవాదాలు. 🙏"
    end

    test "out_of_scope_wo_ar_0fc_te" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "out_of_scope_wo_ar_0fc_te",
          language: :te,
          template_parameters: []
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "ఈ ఆడియో/వీడియోని పంపడానికి మీరు కేటాయించిన సమయాన్ని  మేము అభినందిస్తున్నాము 🙌\n\nమేము ప్రజా ప్రయోజనం ఉన్న ఆడియో/వీడియోలను మరియు ప్రజలను తప్పుదోవ పట్టించే ఆడియో/వీడియోలను మాత్రమే చెక్ చేస్తాము. వ్యక్తిగత, ప్రైవేట్ ఆడియో/వీడియోలను చెక్ చేయము.\n\nమీకు ఏదైనా కంటెంట్ అనుమానస్పదంగా లేదా తప్పుదారి పట్టించే విధంగా కనిపిస్తే, దయచేసి మమ్మల్ని మళ్లీ సంప్రదించడానికి వెనుకాడకండి.\n\nమమ్మల్ని సంప్రదించినందుకు ధన్యవాదాలు. 🙏"
    end

    test "unsupported_language_wo_ar_0fc_te" do
      template = %Template{
        meta: %{
          valid: true,
          template_name: "unsupported_language_wo_ar_0fc_te",
          language: :te,
          template_parameters: []
        }
      }

      {:ok, text} = Factory.eval(template)

      assert text ==
               "🫣 మీరు షేర్ చేసిన మీడియా ప్రస్తుతం మేము సపోర్ట్ చేయని భాషలో ఉంది. మీరు కింద లిస్ట్ లో ఉన్న ఇతర ఫాక్ట్ చెకర్స్  వాట్సాప్ టిప్ లైన్ ని సంప్రదించండి:\n\n➡️Boom: +91-7700906588\n➡️Vishvas News: +91-9599299372\n➡️Factly: +91-9247052470\n➡️THIP: +91-8507885079\n➡️Newschecker: +91-9999499044\n➡️Fact Crescendo: +91-9049053770\n➡️India Today: +91-7370007000\n➡️Newsmobile:+91-1171279799\n➡️Quint WebQoof: +91-9540511818\n➡️Logically Facts: +91-8640070078\n➡️Newsmeter: +91-7482830440\n\nమమ్మల్ని సంప్రదించినందుకు ధన్యవాదాలు.🙏"
    end
  end
end
