defmodule DAUWeb.SlackController do
  @moduledoc """

  ## Overview
  This is a controller to handle Slack Events Payloads. To read more about Slack's Events API, visit: https://docs.slack.dev/apis/events-api/.

  The types of events we want to recieve can be set on Slack-App's event-subscriptions settings. This Controller is created
  to handle message related events (new message, edit message, delete message, etc.). More details about Subscribing to events can be found here: https://docs.slack.dev/apis/events-api/#subscribing.

  Some example payloads of various scenarios can be found in "/test/support/fixtures/slack_payload_fixtures.ex". The same payloads are also used in the test to check this controller "test/dau_web/controllers/slack_controller_payloads_test.ex" as well.

  ## HTTP Responses:
  For a request to be considered successful, Slack only accepts a 200 status code.

  For temporary server downtime or similar scenarios, Slack also allows a response with an HTTP 301 or 302, which it will follows up to two redirects to get a 200 status code.

  Other than that, any status code will be treated as a failed attempt. Upon receiving a failed response, Slack's servers try to resend the request up to 3 times with an increasing time gap. They also send a header that tells us what retry number the request is.

  Related Doc: https://docs.slack.dev/apis/events-api/#error-handling

  ## Broad Flow:
  - The controller first matches the payload for fields that are crucial for processing a valid event.
  - It then verifies if the event_id (unique to each payload) exists in our stored events. If found, it returns a 200 status code, indicating the event was already processed. This handles cases where Slack resends the same payload for delivery confirmation.
  - The payloads along with other crucuial fields are then passed to Slack Module's process_message, where the event is further validated and processed.
  - These archived messages can be viewd in "/slack-archives" route.
  """
  use DAUWeb, :controller
  alias DAU.Slack
  require Logger

  # For Slack endpoint verification
  def create(conn, %{"challenge" => challenge}) do
    conn |> send_resp(200, challenge)
  end

  def create(
        conn,
        %{"event" => %{"type" => _} = event, "event_id" => event_id, "team_id" => team_id} =
          payload
      ) do
    # IO.inspect(payload)

    if Slack.get_event_from_event_id(event_id) == nil do
      case Slack.process_message(event, event_id, team_id, payload) do
        {:ok, :duplicate_message} ->
          send_resp(conn, 200, "Duplicate message, skipping")

        {:ok, _} ->
          send_resp(conn, 200, "")

        {:error, :message_to_edit_not_found} ->
          send_resp(conn, 404, "Message not found for editing")

        {:error, :message_to_delete_not_found} ->
          send_resp(conn, 404, "Message not found for deletion")

        {:error, reason} ->
          Logger.error("Failed to process message: #{inspect(reason)}")
          send_resp(conn, 500, "Internal server error")

        _ ->
          Logger.warning("Unexpected response from process_message")
          send_resp(conn, 200, "")
      end
    else
      send_resp(conn, 200, "Event already processed")
    end
  end

  def create(conn, %{"event" => event}) do
    Logger.warning("Received unsupported event type: #{inspect(get_in(event, ["type"]))}")
    send_resp(conn, 200, "Unsupported event type")
  end

  def create(conn, _params) do
    send_resp(conn, 200, "")
  end
end
