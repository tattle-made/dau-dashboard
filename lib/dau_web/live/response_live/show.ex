defmodule DAUWeb.ResponseLive.Show do
  use DAUWeb, :live_view

  alias DAU.Verification

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:response, Verification.get_response!(id))}
  end

  defp page_title(:show), do: "Show Response"
  defp page_title(:edit), do: "Edit Response"
end
