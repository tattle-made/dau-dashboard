defmodule DAUWeb.FactcheckArticleLive.Show do
  use DAUWeb, :live_view

  alias DAU.Canon

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:factcheck_article, Canon.get_factcheck_article!(id))}
  end

  defp page_title(:show), do: "Show Factcheck article"
  defp page_title(:edit), do: "Edit Factcheck article"
end
