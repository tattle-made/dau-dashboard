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
    # Verify the request signature
    case verify_slack_signature(conn) do
      :ok ->
        handle_slack_event(conn, event, event_id, team_id, payload)

      :error ->
        Logger.warning("Invalid Slack signature received")
        send_resp(conn, 401, "Unauthorized")
    end
  end

  def create(conn, %{"event" => event}) do
    Logger.warning("Received unsupported event type: #{inspect(get_in(event, ["type"]))}")
    send_resp(conn, 200, "Unsupported event type")
  end

  def create(conn, _params) do
    send_resp(conn, 200, "")
  end

  # Private helper functions

  @doc """
  Verifies the Slack request signature to ensure the request came from Slack.

  Slack includes an X-Slack-Request-Timestamp header and an X-Slack-Signature header.
  We verify by:
  1. Extracting the required headers and body from conn
  2. Checking that the timestamp is not more than 5 minutes old (replay attack protection)
  3. Creating a base string: "v0:timestamp:request_body"
  4. Computing an HMAC-SHA256 using the signing secret
  5. Using constant-time comparison to prevent timing attacks
  """
  defp verify_slack_signature(conn) do
    raw_body = conn.assigns[:raw_body]
    signature = get_req_header(conn, "x-slack-signature") |> List.first()
    timestamp = get_req_header(conn, "x-slack-request-timestamp") |> List.first()

    # Check if all required values are present
    if is_nil(raw_body) or is_nil(signature) or is_nil(timestamp) do
      Logger.warning("Missing required headers or body for Slack signature verification")
      :error
    else
      # Verify timestamp is not more than 5 minutes old (replay attack protection)
      case verify_timestamp(timestamp) do
        :ok ->
          verify_signature(signature, timestamp, raw_body)

        :error ->
          Logger.warning("Slack request timestamp is too old (potential replay attack)")
          :error
      end
    end
  end

  defp verify_timestamp(timestamp_str) do
    case Integer.parse(timestamp_str) do
      {timestamp, ""} ->
        current_time = System.system_time(:second)
        time_diff = abs(current_time - timestamp)

        # Allow 5 minutes (300 seconds) of time difference
        if time_diff > 300 do
          :error
        else
          :ok
        end

      :error ->
        Logger.warning("Invalid timestamp format in Slack request")
        :error
    end
  end

  defp verify_signature(signature, timestamp, raw_body) do
    case System.get_env("SLACK_SIGNING_SECRET") do
      nil ->
        Logger.error("SLACK_SIGNING_SECRET not configured")
        :error

      secret ->
        base_string = "v0:#{timestamp}:#{raw_body}"

        computed_signature =
          :crypto.mac(:hmac, :sha256, secret, base_string)
          |> Base.encode16(case: :lower)
          |> then(&("v0=" <> &1))

        # Constant-time comparison to prevent timing attacks
        if Plug.Crypto.secure_compare(computed_signature, signature) do
          :ok
        else
          :error
        end
    end
  end

  defp handle_slack_event(conn, event, event_id, team_id, payload) do
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
end
