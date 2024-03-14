defmodule DAUWeb.SearchLive.Detail do
  alias DAU.Feed
  alias DAU.UserMessage.MessageDelivery
  use DAUWeb, :live_view
  use DAUWeb, :html

  def render(assigns) do
    ~H"""
    <section class="w-full md:w-3/4 lg:w-1/2 m-auto flex flex-col gap-4">
      <.back navigate={~p"/demo/query/pg/1"}>Back to feed</.back>
      <div class="w-full">
        <div class="flex flex-row gap-1">
          <div class="w-1/2 border-2 border-green-50 overflow-hidden">
            <.query type={to_string(@query.media_type)} url={@query.media_urls |> hd} />
          </div>
          <div class="w-1/2">
            <div class="flex flex-row wrap gap-4">
              <p class="p-2 bg-gray-100 rounded-lg">
                <%= "taken up by : #{Map.get(@query, :taken_by, "no one")}" %>
              </p>
            </div>
          </div>
        </div>
      </div>

      <div class="">
        <div class="w-full p-4 rounded-md border-2 border-gray-200">
          <p class="text-lg">Verification Notes</p>
          <p class="text-sm text-gray-400">Added by DAU secratariat</p>

          <div class="h-4" />
          <div class="flex flex-row flex-wrap gap-2">
            <span class="text-md"><%= @query.verification_note %></span>
          </div>
          <div class="h-2" />
          <div class="flex flex-row flex-wrap gap-1">
            <%= unless is_nil(@query.tags) do %>
              <%= for tag <- @query.tags do %>
                <div class="flex flex-row items-center gap-x-2 bg-green-200  p-1 rounded-md border-2 border-green-50 w-fit">
                  <p class="text-stone-800 text-xs"><%= tag %></p>
                </div>
              <% end %>
            <% end %>
          </div>
          <!--
          <div class="h-2" />
          <button
            id="dropdownContainer"
            data-dropdown-toggle="dropdownContent"
            class="bg-green-50 p-1 text-xs flex flex-row align-center"
          >
            Add tags
            <svg
              class="w-3 h-3 ml-2"
              aria-hidden="true"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
              xmlns="http://www.w3.org/2000/svg"
            >
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7">
              </path>
            </svg>
          </button>
          <div id="dropdownContent" class="hidden p-2 bg-slate-200">
            <div class="flex flex-col">
              <div class="p-1">
                <input type="checkbox" phx-click="test-click" id="id-opt-1" value="value-opt-1" />
                <label for="id-opt-1" class="text-xs"> Suspected Cheapfake </label>
              </div>

              <div class="p-1">
                <input type="checkbox" id="id-opt-1" value="value-opt-1" />
                <label for="id-opt-1" class="text-xs"> Suspected Deepfake </label>
              </div>
              <div class="p-1">
                <input type="checkbox" id="id-opt-1" value="value-opt-1" />
                <label for="id-opt-1" class="text-xs"> Deepfake </label>
              </div>
              <div class="p-1">
                <input type="checkbox" id="id-opt-1" value="value-opt-1" />
                <label for="id-opt-1" class="text-xs"> Cheapfake </label>
              </div>
              <div class="p-1">
                <input type="checkbox" id="id-opt-1" value="value-opt-1" />
                <label for="id-opt-1" class="text-xs"> AI-voice </label>
              </div>
              <div class="p-1">
                <input type="checkbox" id="id-opt-1" value="value-opt-1" />
                <label for="id-opt-1" class="text-xs"> AI-video </label>
              </div>
              <div class="p-1">
                <input type="checkbox" id="id-opt-1" value="value-opt-1" />
                <label for="id-opt-1" class="text-xs"> Manipulated video </label>
              </div>
              <div class="p-1">
                <input type="checkbox" id="id-opt-1" value="value-opt-1" />
                <label for="id-opt-1" class="text-xs"> Manipulated audio </label>
              </div>
              <div class="p-1">
                <input type="checkbox" id="id-opt-1" value="value-opt-1" />
                <label for="id-opt-1" class="text-xs"> faceswap </label>
              </div>
              <div class="p-1">
                <input type="checkbox" id="id-opt-1" value="value-opt-1" />
                <label for="id-opt-1" class="text-xs"> AI-image </label>
              </div>
              <div class="p-1">
                <input type="checkbox" id="id-opt-1" value="value-opt-1" />
                <label for="id-opt-1" class="text-xs"> political fakes </label>
              </div>
              <div class="p-1">
                <input type="checkbox" id="id-opt-1" value="value-opt-1" />
                <label for="id-opt-1" class="text-xs"> Phase-1 </label>
              </div>
              <div class="p-1">
                <input type="checkbox" id="id-opt-1" value="value-opt-1" />
                <label for="id-opt-1" class="text-xs"> Phase-2 </label>
              </div>
              <div class="p-1">
                <input type="checkbox" id="id-opt-1" value="value-opt-1" />
                <label for="id-opt-1" class="text-xs"> Real Video, AI Voice </label>
              </div>
              <div class="p-1">
                <input type="checkbox" id="id-opt-1" value="value-opt-1" />
                <label for="id-opt-1" class="text-xs"> Real Video, Real Voice </label>
              </div>
              <div class="p-1">
                <input type="checkbox" id="id-opt-1" value="value-opt-1" />
                <label for="id-opt-1" class="text-xs"> AI Video, Real Voice </label>
              </div>
              <div class="p-1">
                <input type="checkbox" id="id-opt-1" value="value-opt-1" />
                <label for="id-opt-1" class="text-xs"> Real Video, Real Voice </label>
              </div>
              <div class="p-1">
                <input type="checkbox" id="id-opt-1" value="value-opt-1" />
                <label for="id-opt-1" class="text-xs"> Out of scope </label>
              </div>
            </div>
          </div>
          -->
        </div>
      </div>
      <!--
      <div class="w-full">
        <div class="w-full lg:w-1/2 p-2 rounded-md border-2 border-green-100">
          <p class="text-lg">Factcheck Articles</p>
          <div class=" flex flex-row items-center gap-x-2">
            <p class="text-stone-800 text-xs">kritika has linked an article</p>
            <span class="hero-link w-3 h-3 cursor-pointer" />
          </div>
          <div class="flex flex-row items-center gap-x-2">
            <p class="text-stone-800 text-xs">rakesh has linked an article</p>
            <span class="hero-link w-3 h-3 cursor-pointer" />
          </div>
          <div class="py-2">
            <textarea
              id="message"
              rows="1"
              class="block p-2.5 w-full text-xs text-gray-900 bg-gray-50 rounded-sm border border-gray-300 focus:ring-green-300 focus:border-green-300 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-green-500 dark:focus:border-green-500"
              placeholder="Add link"
            ></textarea>
          </div>
        </div>
      </div>

      <div class="flex flex-row gap-1">
        <div class="w-full p-4 rounded-md border-2 border-gray-200">
          <p class="text-lg">Resources</p>
          <p class="text-xs text-gray-400">Share relevant resources with the community</p>
          <textarea
            id="user-message"
            rows="1"
            class="block p-2.5 w-full text-xs text-gray-900 bg-gray-50 rounded-sm border border-gray-300 focus:ring-green-300 focus:border-green-300 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-green-500 dark:focus:border-green-500"
            placeholder="Add Resource"
          ></textarea>
        </div>
      </div>

      <div class="flex flex-row gap-1">
        <div class="w-full p-4 rounded-md border-2 border-gray-200">
          <p class="text-lg">Assessment Report</p>
          <textarea
            id="user-message"
            rows="1"
            class="block p-2.5 w-full text-xs text-gray-900 bg-gray-50 rounded-sm border border-gray-300 focus:ring-green-300 focus:border-green-300 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-green-500 dark:focus:border-green-500"
            placeholder="Add Report Link"
          ></textarea>
        </div>
      </div>
      -->
      <div class="flex flex-row gap-1">
        <div class="w-full p-4 rounded-md border-2 border-gray-200">
          <p class="text-lg">User Response</p>
          <div class="mt-1">
            <form phx-submit="send-to-user" class="flex flex-col gap-1">
              <textarea
                class="block p-2.5 w-full text-xs text-gray-900 bg-gray-50 rounded-sm border border-gray-300 focus:ring-green-300 focus:border-green-300 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-green-500 dark:focus:border-green-500"
                rows="4"
                id="assessment-report"
                name="assessment-report"
                value={"#{Map.get(@query, :user_response, "")}"}
              />
              <button
                class="border-2 border-green-200 bg-green-100 mt-2 rounded-md hover:bg-green-200 hover:cursor-pointer w-fit"
                type="submit"
              >
                <p class="text-xs p-2">Send to User</p>
              </button>
            </form>
          </div>
        </div>
      </div>
    </section>
    """
  end

  def mount(params, session, socket) do
    # IO.inspect(params)
    # IO.inspect(session)
    # IO.inspect(socket)
    query = ""
    {:ok, assign(socket, :query, query)}
  end

  def handle_params(%{"id" => id}, uri, socket) do
    query = Feed.get_feed_item_by_id(id)
    IO.inspect(query)
    {:noreply, assign(socket, :query, query)}
  end

  # def handle_event(event, unsigned_params, socket) do
  # end

  def handle_event("test-click", value, socket) do
    IO.inspect(value)
    query = socket.assigns.query <> value["value"]
    {:noreply, assign(socket, :query, query)}
  end

  def handle_event("send-to-user", %{"assessment-report" => assessment_report}, socket) do
    query_id = socket.assigns.query.id
    Feed.send_assessment_report_to_user(query_id, assessment_report)
    # MessageDelivery.send_message_to_bsp(sender_number, assessment_report)
    {:noreply, socket}
  end
end
