defmodule DAU.Vendor.TurnTest do
  use ExUnit.Case
  alias DAU.Vendor.Turn

# These test cases will be skipped when "mix test" will run. To include these test run "mix test --include skip"

# To run this test file specifically, run "mix test test/dau/vender/turn_test.exs --include skip"

# Edit the phone number in both the tests before running them them


@tag :skip
  describe "send_message_to_bsp/2" do
    test "makes a successful network call and returns a 200 status" do
      phone_number = "91999999"
      message = "Testing Sending Message for Turn BSP."


      {:ok, response} = DAU.Vendor.Turn.send_message_to_bsp(phone_number, message)


      assert response.status_code == 200


      {:ok, response_body} = Jason.decode(response.body)


      assert %{"messages" => [%{"id" => _msg_id}]} = response_body
    end

  end

  @tag :skip
  describe "send_template_to_bsp/2" do
    test "makes a successful network call and returns a 200 status" do

      # Following are the variables which can be replaced to test various scenarios.
      # NOTE: The payload sent should be as per the name.
      # Ex- if name has wo_ar (without assessment report), then in payload assessment report should be set to nil


      # Template Name to check without assessment report and 2 fact checks
      name1 = "cheapfake_wo_ar_2fc_en"
      factcheck_2articles =  [
        %{
          domain: "Vishvas News",
          url: "https://www.vishvasnews.com/viral/fact-check-chhattisgarh-cm-vishnu-deo-sai-did-not-appeal-to-voters-in-favor-of-congress-candidate-bhupesh-baghel-a-viral-video-is-fake-and-altered/"
        },
        %{
          domain: "Factly",
          url: "https://factly.in/a-clipped-video-is-shared-as-visuals-of-modi-commenting-against-the-reservation-system/"
        }
      ]

      name2 = "cheapfake_w_ar_0fc_en" # with assessment report 0 fc articles
      assesment_rep = "www.google.com"

      name3="cheapfake_wo_ar_0fc_en" # Cheapfake with no report and no articles. Set assessment_report to nil and factcheck_articles to [].

      # Prepare template metadata
      template_meta = %{
        template_name: name3,
        language: "en",
        assessment_report: nil, # Should be nil if no assessment report is there.
        factcheck_articles: [] #Should be an empty array if no articles.
      }

      phone_number = "919999xxx9x"


      {:ok,response} = Turn.send_template_to_bsp(phone_number, template_meta)

      assert response.status_code == 200


      {:ok, response_body} = Jason.decode(response.body)


      assert %{"messages" => [%{"id" => _msg_id}]} = response_body
  end
end
end
