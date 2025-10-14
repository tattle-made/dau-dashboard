defmodule DAUWeb.SlackControllerPayloadsTest do
  # Set to false to avoid DB connection issues
  use DAUWeb.ConnCase, async: false

  alias DAU.Repo
  alias DAU.Slack.Event, as: SlackEvent
  alias DAU.Slack
  alias DAU.SlackPayloadFixtures
  import DAU.SlackPayloadFixtures

  test "process Slack payloads in chronological order", %{conn: conn} do
    DAU.SlackPayloadFixtures.all_payloads()
    |> Enum.with_index()
    |> Enum.each(fn {payload, index} ->
      test_name = payload["test"] || "Test case #{index + 1}"
      test_case = "[#{index + 1}] #{test_name}"

      conn = post(conn, "/slack", payload)
      assert conn.status in [200], "Test case Failed: #{test_case}"
      IO.puts("✅ #{test_case}")

      if event_id = payload["event_id"] do
        assert Repo.get_by(SlackEvent, event_id: event_id), "Test case Failed, unable to get processed event_id : #{test_case}"
      end

      Process.sleep(50)
    end)
  end

end
