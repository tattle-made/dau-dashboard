defmodule DAU.Vender.Gupshup.DeliveryReportTest do
  alias DAU.Vendor.Gupshup.DeliveryReport
  use DAU.DataCase

  test "make delivery report for outbox" do
    params = %{
      "_json" => [
        %{
          "cause" => "24HR_TimeExceed",
          "channel" => "WHATSAPP",
          "destAddr" => "919466953284",
          "errorCode" => "101",
          "eventTs" => "1_712_241_654_000",
          "eventType" => "FAILED",
          "externalId" => "5145722132009541678-004352f6-0511-4d73-be33-e95af041f8a1",
          "srcAddr" => "TESTSM"
        }
      ]
    }

    result = DeliveryReport.make_delivery_report_for_outbox(params)
    IO.inspect(result)
  end

  test "make red report for outbox" do
    params = %{
      "_json" => [
        %{
          "cause" => "READ",
          "channel" => "WHATSAPP",
          "destAddr" => "919605048908",
          "errorCode" => "026",
          "eventTs" => 1_712_929_509_000,
          "eventType" => "READ",
          "externalId" => "5145722132009541678-004352f6-0511-4d73-be33-e95af041f8a1",
          "srcAddr" => "TESTSM"
        }
      ]
    }

    {msg_id, delivery_report_params} = DeliveryReport.make_delivery_report_for_outbox(params)
    assert msg_id == "004352f6-0511-4d73-be33-e95af041f8a1"
    assert delivery_report_params.delivery_status == "success"

    assert delivery_report_params.delivery_report ==
             "026 : READ : READ : 5145722132009541678-004352f6-0511-4d73-be33-e95af041f8a1"
  end
end
