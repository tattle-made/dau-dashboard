defmodule SeedSlackData do
  @moduledoc """
  Take data from Slack_payload_fixtures (that was created for testing), and seed it by passing the data through Slack controller.
  """


  alias DAUWeb.SlackController

  def seed do
    Code.require_file("test/support/fixtures/slack_payload_fixtures.ex")

    # Get all payloads from fixtures and process each one
    DAU.SlackPayloadFixtures.all_payloads()
    |> Enum.each(fn payload ->
      try do
        conn =
          Phoenix.ConnTest.build_conn()
          |> Plug.Conn.put_req_header("content-type", "application/json")

        _response = SlackController.create(conn, payload)
      rescue
        e ->
          IO.inspect(e, label: "Error processing payload")
      end
    end)
  end
end
