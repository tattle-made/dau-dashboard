defmodule DAU.BSP.GupshupFixture do
  def failure_report(e_id, msg_id) do
    %{
      "_json" => [
        %{
          "cause" => "24HR_TimeExceed",
          "channel" => "WHATSAPP",
          "destAddr" => "919466953284",
          "errorCode" => "101",
          "eventTs" => "1_712_241_654_000",
          "eventType" => "FAILED",
          "externalId" => "#{e_id}-#{msg_id}",
          "srcAddr" => "TESTSM"
        }
      ]
    }
  end
end
