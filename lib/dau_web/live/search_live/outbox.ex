defmodule DAUWeb.SearchLive.Outbox do
  alias DAU.UserMessage
  use DAUWeb, :live_view
  use DAUWeb, :html

  def mount(_params, _session, socket) do
    outbox = UserMessage.list_outbox()
    socket = assign(socket, :outbox, outbox)
    {:ok, socket}
  end

  def handle_event("send-response", _unsigned_params, socket) do
    {:noreply, socket}
  end
end
