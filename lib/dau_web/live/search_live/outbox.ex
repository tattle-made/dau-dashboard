defmodule DAUWeb.SearchLive.Outbox do
  alias DAU.UserMessage
  use DAUWeb, :live_view
  use DAUWeb, :html

  def mount(_params, _session, socket) do
    outbox = UserMessage.list_outbox()
    socket = assign(socket, :outbox, outbox)
    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    pg = String.to_integer(params["pg"] || "0")
    outbox = UserMessage.list_outbox(pg)

    socket = assign(socket, :outbox, outbox)
    {:noreply, socket}
  rescue
    _err -> {:noreply, socket}
  end

  def handle_event("send-response", _unsigned_params, socket) do
    {:noreply, socket}
  end

  defp humanize_date(date) do
    Timex.to_datetime(date, "Asia/Calcutta")
    |> Calendar.strftime("%a %d-%m-%Y %I:%M %P")
  end
end
