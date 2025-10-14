defmodule DAUWeb.SlackController do
  use DAUWeb, :controller
  alias DAU.Slack
  require Logger

  # For Slack endpoint verification
  def create(conn, %{"challenge" => challenge}) do
    conn |> send_resp(200, challenge)
  end

  def create(conn, %{"event" => %{"type" => _} = event, "event_id" => event_id, "team_id" => team_id} = payload) do
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
