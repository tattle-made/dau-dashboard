defmodule DAUWeb.Components.MatchReview do
  alias DAU.MediaMatch.Blake2B
  use DAUWeb, :live_component
  alias Phoenix.LiveView.JS

  def handle_event("test", value, socket) do
    IO.puts("===here===")
    matches = Blake2B.get_matches_by_common_id(11)
    IO.inspect(matches)
    socket = socket |> assign(:suggested_matches, matches.result)
    {:noreply, socket}
  end

  def update(assigns, socket) do
    IO.puts("===here in update===")
    id = assigns.common_id
    matches = Blake2B.get_matches_by_common_id(id)
    socket = socket |> assign(:suggested_matches, matches.result)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <div id="additional-content" class="mt-2">
        <h1>Matches</h1>
        <%= for match <- @suggested_matches do %>
          <div class="border border-slate-400 p-2 mt-2 mb-4 ">
            <.link
              navigate={~p"/demo/query/#{match.feed_id}"}
              class="text-sm leading-6 text-teal-700 hover:text-teal-500"
            >
              View query
            </.link>
            <div class="mt-4">
              <div :if={match.response != nil}>
                <p class="whitespace-pre-wrap w-full"><%= match.response %></p>
              </div>
              <div :if={match.response == nil}>
                <p>No Response added</p>
              </div>
            </div>
          </div>
        <% end %>

        <button class="mt-4 bg-slate-300 px-4 py-1 rounded-sm">use</button>
      </div>
    </div>
    """
  end
end
