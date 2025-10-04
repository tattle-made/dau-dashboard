defmodule DAUWeb.SlackControllerPayloadsTest do
  # Set to false to avoid DB connection issues
  use DAUWeb.ConnCase, async: false

  alias DAU.Repo
  alias DAU.Slack.Event, as: SlackEvent
  alias DAU.Slack
  alias DAU.SlackPayloadFixtures
  import DAU.SlackPayloadFixtures

  test "process Slack payloads in chronological order", %{conn: conn} do
    for payload <- DAU.SlackPayloadFixtures.all_payloads() do
      conn = post(conn, "/slack", payload)

      assert conn.status in [200]

      IO.puts("passed")

      if event_id = payload["event_id"] do
        assert Repo.get_by(SlackEvent, event_id: event_id)
      end

      Process.sleep(1000)
    end
  end

end
