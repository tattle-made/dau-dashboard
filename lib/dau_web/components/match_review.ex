defmodule DAUWeb.Components.MatchReview do
  alias DAU.UserMessage
  alias DAU.Feed.Common
  alias DAU.Repo
  alias DAU.MediaMatch.Blake2B
  alias DAUWeb.SearchLive.Detail
  use DAUWeb, :live_component
  require Logger

  def handle_event("reuse-response", value, socket) do
    src = value["value"] |> String.to_integer()
    target = socket.assigns.common_id


    socket =
      with {:ok, common} <- Blake2B.copy_response_fields(src, target),
           {:ok, query} <- UserMessage.add_response_to_outbox(common),
           template_meta <- Detail.get_templatized_response_paramters(common),
           {:ok} <- UserMessage.send_response(query.user_message_outbox,template_meta) do
        socket
        |> redirect(to: ~p"/demo/query/#{target}")
      else
        error ->
          Logger.error(error)

          socket
          |> put_flash(:info, "Error caused while importing response. Please reach out to admin")
      end

    {:noreply, socket}
  end

  def update(assigns, socket) do
    id = assigns.common_id
    matches = Blake2B.get_matches_by_common_id(id)
    socket = socket |> assign(:common_id, id) |> assign(:suggested_matches, matches.result)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <div id="additional-content" class="mt-2">
        <h1 class="text-lg">Matches</h1>
        <%= for match <- @suggested_matches do %>
          <div class="border border-slate-400 mt-4 mb-4 rounded-md overflow-hidden">
            <div class="bg-slate-50 p-2">
              <div class="flex flex-row gap-2 align-start flex-wrap">
                <p class=""><%= match.sender_number %></p>
                <p class=""><%= match.language %></p>
                <p class=""><%= match.verification_status %></p>
                <p class="flex-grow"></p>
                <.link
                  navigate={~p"/demo/query/#{match.feed_id}"}
                  class="text-sm leading-6 text-teal-700 hover:text-teal-500"
                >
                  <div class="flex flex-row gap-1">
                    <p><%= match.feed_id %></p>
                    <.icon name="hero-arrow-up-right" class="h-5 w-5" />
                  </div>
                </.link>
              </div>
            </div>
            <div class="mt-4 p-2">
              <div :if={match.response != nil}>
                <p class="whitespace-pre-wrap w-full mt-4"><%= match.response %></p>
                <div :if={match.verification_status != nil}>
                  <button
                    type="button"
                    value={match.feed_id}
                    phx-click="reuse-response"
                    phx-target={@myself}
                    class="px-4 py-2 bg-teal-100 rounded-md mt-4"
                  >
                    Reuse response
                  </button>
                </div>
              </div>
              <div :if={match.response == nil}>
                <p>No Response added</p>
              </div>
            </div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
