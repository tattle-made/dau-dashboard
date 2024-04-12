defmodule DAU.UserMessage.OutboxTest do
  alias DAU.OutboxFixtures
  alias DAU.UserMessage.Outbox
  use DAU.DataCase

  test "long delivery reports should be sliced before insert" do
    outbox = OutboxFixtures.outbox_fixture()
    # IO.inspect(outbox)

    long_report =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer lobortis laoreet malesuada. Ut eu fermentum diam, eu feugiat tellus. Nulla facilisi. Quisque bibendum consectetur lorem, sed tempor augue posuere at. Nam vestibulum condimentum vulputate. Interdum et malesuada fames ac ante ipsum primis in faucibus. Suspendisse commodo metus purus, nec interdum lacus luctus et. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum ut finibus elit. Sed a egestas nibh. Aenean malesuada dolor justo, id luctus nibh hendrerit quis. Curabitur vel libero mauris. Nunc id risus eleifend, vehicula ex sit amet, rutrum augue. "

    changeset =
      Outbox.delivery_report_changeset(outbox, %{
        "delivery_status" => "success",
        "delivery_report" => long_report
      })

    assert String.length(changeset.changes.delivery_report) == 255
    # IO.inspect(changeset)
  end

  test "add bsp status to outbox" do
    response_body =
      "{\"response\":{\"phone\":\"919605048908\",\"details\":\"\",\"id\":\"5145380278493376596-affbbfbf-f374-410d-b602-5dcad69abd5e\",\"status\":\"success\"}}"

    {:ok, {txn_id, msg_id}} = Outbox.parse_bsp_status_response(response_body)
    assert txn_id == "5145380278493376596"
    assert msg_id == "affbbfbf-f374-410d-b602-5dcad69abd5e"
  end
end
