defmodule DAUWeb.SearchLive.Component do
  use DAUWeb, :live_view
  use DAUWeb, :html

  def render(assigns) do
    ~H"""
    <div class="border-2 border-red-400 p-2">
      <my-test></my-test>
    </div>
    <div class="h-4" />
    <div class="border-2 border-red-200 p-2">
      <simple-greeting />
    </div>
    """
  end

  def mount(params, session, socket) do
    {:ok, socket}
  end

  def handle_event("add-tag", unsigned_params, socket) do
    {:ok, socket}
  end

  def handle_event("remove-tag", unsigned_params, socket) do
    {:ok, socket}
  end
end
