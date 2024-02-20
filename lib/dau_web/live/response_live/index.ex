defmodule DAUWeb.ResponseLive.Index do
  use DAUWeb, :live_view

  alias DAU.Verification
  alias DAU.Verification.Response

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :response_collection, Verification.list_response())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Response")
    |> assign(:response, Verification.get_response!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Response")
    |> assign(:response, %Response{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Response")
    |> assign(:response, nil)
  end

  @impl true
  def handle_info({DAUWeb.ResponseLive.FormComponent, {:saved, response}}, socket) do
    {:noreply, stream_insert(socket, :response_collection, response)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    response = Verification.get_response!(id)
    {:ok, _} = Verification.delete_response(response)

    {:noreply, stream_delete(socket, :response_collection, response)}
  end
end
