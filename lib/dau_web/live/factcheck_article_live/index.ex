defmodule DAUWeb.FactcheckArticleLive.Index do
  use DAUWeb, :live_view

  alias DAU.Canon
  alias DAU.Canon.FactcheckArticle

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :factcheck_articles, Canon.list_factcheck_articles())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Factcheck article")
    |> assign(:factcheck_article, Canon.get_factcheck_article!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Factcheck article")
    |> assign(:factcheck_article, %FactcheckArticle{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Factcheck articles")
    |> assign(:factcheck_article, nil)
  end

  @impl true
  def handle_info({DAUWeb.FactcheckArticleLive.FormComponent, {:saved, factcheck_article}}, socket) do
    {:noreply, stream_insert(socket, :factcheck_articles, factcheck_article)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    factcheck_article = Canon.get_factcheck_article!(id)
    {:ok, _} = Canon.delete_factcheck_article(factcheck_article)

    {:noreply, stream_delete(socket, :factcheck_articles, factcheck_article)}
  end
end
