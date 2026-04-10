defmodule DAUWeb.ManipulatedMediaLive.Index do
  alias DAU.Feed.Common
  use DAUWeb, :live_view

  alias DAU.Canon
  alias DAU.Canon.ManipulatedMedia
  alias Permission

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
  def handle_info(
        {DAUWeb.ManipulatedMediaLive.FormComponent, {:saved, manipulated_media}},
        socket
      ) do
    {:noreply, stream_insert(socket, :manipulated_media_collection, manipulated_media)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    user = socket.assigns.current_user
    manipulated_media = Canon.get_manipulated_media!(id)

    case Canon.delete_manipulated_media(manipulated_media, user) do
      {:ok, _} ->
        {:noreply, stream_delete(socket, :manipulated_media_collection, manipulated_media)}

      {:error, :unauthorized} ->
        {:noreply, put_flash(socket, :error, "You are not authorized to perform this action.")}

      error ->
        IO.inspect(error)
        {:noreply, put_flash(socket, :error, "Something went wrong.")}
    end
  end
end
