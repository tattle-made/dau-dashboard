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

    {msg_id, delivery_report} = DeliveryReport.make_delivery_report_for_outbox(params)
    assert msg_id == "004352f6-0511-4d73-be33-e95af041f8a1"
    assert delivery_report.delivery_status == "error"

    assert delivery_report.delivery_report ==
             "101 : FAILED : 24HR_TimeExceed : 5145722132009541678-004352f6-0511-4d73-be33-e95af041f8a1"
  end

  test "make read report for outbox" do
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

    {msg_id, delivery_report} = DeliveryReport.make_delivery_report_for_outbox(params)
    assert msg_id == "004352f6-0511-4d73-be33-e95af041f8a1"
    assert delivery_report.delivery_status == "success"

    assert delivery_report.delivery_report ==
             "026 : READ : READ : 5145722132009541678-004352f6-0511-4d73-be33-e95af041f8a1"
  end
end
