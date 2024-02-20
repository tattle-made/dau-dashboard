defmodule DAUWeb.AnalysisLive.Index do
  use DAUWeb, :live_view

  alias DAU.Canon
  alias DAU.Canon.Analysis

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :analysis_collection, Canon.list_analysis())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Analysis")
    |> assign(:analysis, Canon.get_analysis!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Analysis")
    |> assign(:analysis, %Analysis{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Analysis")
    |> assign(:analysis, nil)
  end

  @impl true
  def handle_info({DAUWeb.AnalysisLive.FormComponent, {:saved, analysis}}, socket) do
    {:noreply, stream_insert(socket, :analysis_collection, analysis)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    analysis = Canon.get_analysis!(id)
    {:ok, _} = Canon.delete_analysis(analysis)

    {:noreply, stream_delete(socket, :analysis_collection, analysis)}
  end
end
