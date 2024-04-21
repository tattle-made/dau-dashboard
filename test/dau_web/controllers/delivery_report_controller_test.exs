defmodule DAUWeb.DeliveryReportControllerTest do
  alias DAU.UserMessage.Outbox
  alias DAU.Repo
  alias DAU.OutboxFixtures
  use DAUWeb.ConnCase, async: true

  test "add valid delivery report to outbox", %{conn: conn} do
    e_id = "5145722132009541678"
    %{id: msg_id} = outbox = OutboxFixtures.outbox_fixture(%{e_id: e_id})

    params = [
      %{
        "cause" => "24HR_TimeExceed",
        "channel" => "WHATSAPP",
        "destAddr" => "919466953284",
        "errorCode" => "101",
        "eventTs" => 1_712_241_654_000,
        "eventType" => "FAILED",
        "externalId" => "5139951980916883671-#{msg_id}",
        "srcAddr" => "TESTSM"
      }
    ]

    conn = post(conn, ~p"/gupshup/delivery-report", _json: params)
    json_response(conn, 200)
    outbox_after = Repo.get(Outbox, outbox.id)
    assert outbox_after.e_id == outbox.e_id
    assert outbox.id == msg_id
  end

  test "adding delivery report with incorrect msg_id returns 400", %{conn: conn} do
    params = [
      %{
        "cause" => "24HR_TimeExceed",
        "channel" => "WHATSAPP",
        "destAddr" => "919466953284",
        "errorCode" => "101",
        "eventTs" => 1_712_241_654_000,
        "eventType" => "FAILED",
        "srcAddr" => "TESTSM",
        "externalId" => "5139951980916883671-a-made-up-uuid"
      }
    ]

    conn = post(conn, ~p"/gupshup/delivery-report", _json: params)
    body = json_response(conn, 400)
    assert body["status"] == "invalid_request"
    # IO.inspect(body)
  end

  @doc """
  The data of interest from gupshup is within a field called _json.
  This test checks what happens if this contract is broken.
  """
  test "incorrect param name params return 400", %{conn: conn} do
    params = [
      %{
        "cause" => "24HR_TimeExceed",
        "channel" => "WHATSAPP",
        "destAddr" => "919466953284",
        "errorCode" => "101",
        "eventTs" => 1_712_241_654_000,
        "eventType" => "FAILED",
        "srcAddr" => "TESTSM"
      }
    ]

    conn = post(conn, ~p"/gupshup/delivery-report", invalid_name: params)
    _body = json_response(conn, 400)
  end
end
