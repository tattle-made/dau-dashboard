defmodule DAUWeb.SearchLive.Component do
  use DAUWeb, :live_view
  use DAUWeb, :html

  def render(assigns) do
    ~H"""
    <div class="h-4" />
    <div class="border-2 border-red-200 p-2">
      <div id="all-tags" class="flex flex-row gap-2 p-2 bg-red-50">
        <%= for tag <- @tags do %>
          <p class="text-lg" phx-click="remove-tag"><%= tag %></p>
        <% end %>
      </div>
      <input id="current-tag" type="text" />
      <button class="bg-red-300 px-4" phx-click={JS.push("add-tag")}>add</button>
    </div>
    """
  end

  def mount(params, session, socket) do
    tags = ["one"]
    {:ok, assign(socket, :tags, tags)}
  end

  def handle_event("add-tag", unsigned_params, socket) do
    IO.puts(~c"add tag event got on server")
    # {:noreply, socket}
    {:noreply, update(socket, :tags, &["two" | &1])}
  end

  def handle_event("remove-tag", unsigned_params, socket) do
    IO.puts("tag removed")
    {:noreply, socket}
  end
end

# <%= for query <- @queries do %>
#       <div class="rounded-lg py-2 my-2 border-2 border-slate-100 ">
#         <.query query={query} />
#       </div>
#     <% end %>
