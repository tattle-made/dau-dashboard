defmodule DAUWeb.ManipulatedMediaLive.Index do
  use DAUWeb, :live_view

  alias DAU.Canon
  alias DAU.Canon.ManipulatedMedia

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :manipulated_media_collection, Canon.list_manipulated_media())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Manipulated media")
    |> assign(:manipulated_media, Canon.get_manipulated_media!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Manipulated media")
    |> assign(:manipulated_media, %ManipulatedMedia{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Manipulated media")
    |> assign(:manipulated_media, nil)
  end

  @impl true
  def handle_info({DAUWeb.ManipulatedMediaLive.FormComponent, {:saved, manipulated_media}}, socket) do
    {:noreply, stream_insert(socket, :manipulated_media_collection, manipulated_media)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    manipulated_media = Canon.get_manipulated_media!(id)
    {:ok, _} = Canon.delete_manipulated_media(manipulated_media)

    {:noreply, stream_delete(socket, :manipulated_media_collection, manipulated_media)}
  end
end
