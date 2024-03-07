defmodule DAUWeb.SearchLive.Index do
  alias DauWeb.SearchLive.Data
  use DAUWeb, :live_view
  use DAUWeb, :html

  @spec render(any()) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <h1 class="text-xl font-normal text-slate-900 mb-2">
      Showing all queries
    </h1>

    <div class="flex flex-col sm:flex-row">
      <div class="h-fit w-full sm:w-1/5 sm:h-fit flex flex-row gap-4 sm:flex-col mr-4 border-e border-zinc-200">
        <div>
          <p class="py-2">Feeds</p>
          <.checkbox label="Common" checked={true} />
          <.checkbox label="Claimed by me" checked={false} />
        </div>
        <div>
          <p class="py-2">Date Range</p>
          <div class="flex flex-col gap-2">
            <div class="flex flex-col gap-1">
              <label class="text-xs" for="start">From</label>
              <input
                class="w-fit text-xs focus:ring-green-900 ring-green-900 outline-0"
                type="date"
                id="from-date"
                name="to-date"
                value=""
                min="2024-02-01"
                max="2024-12-01"
              />
            </div>
            <div class="flex flex-col gap-1">
              <label class="text-xs" for="start">To</label>
              <input
                class="w-fit text-xs focus:ring-green-900 ring-green-900"
                type="date"
                id="to-date"
                name="to-date"
                value=""
                min="2024-02-01"
                max="2024-12-01"
              />
            </div>
          </div>
        </div>
        <div>
          <p class="py-2">Status</p>
          <.checkbox label="Unseen" checked={true} />
          <.checkbox label="Verification Complete" checked={false} />
          <.checkbox label="Answered" checked={false} />
        </div>
        <div>
          <p class="py-2">Type</p>

          <div class="px-2">
            <.checkbox label="Video" checked={true} />
            <.checkbox label="Audio" checked={false} />
          </div>
        </div>
        <div>
          <p class="py-2">Sort</p>
          <div class="px-2">
            <.checkbox label="Newest First" checked={true} />
            <.checkbox label="Oldest First" checked={false} />
            <.checkbox label="Virality" checked={false} disabled={true} />
          </div>
        </div>
      </div>

      <div class="w-full sm:w-4f/5">
        <div
          :if={@selection != []}
          class="flex flex-row gap-4 align-center border-2 border-zinc-200 p-2 rounded-lg"
        >
          <button class="p-1 bg-gray-200 rounded-md h-fit" phx-click="claim">
            claim
          </button>
          <button class="p-1 bg-gray-200 rounded-md h-fit" phx-click="mark-as-spam">
            mark as spam
          </button>
          <button class="p-1 bg-red-400 rounded-md h-fit" phx-click="delete">delete</button>
        </div>
        <.table id="queries" rows={@queries}>
          <:col :let={query} label="select">
            <input
              type="checkbox"
              value={query.id}
              phx-click="select-one"
              phx-value-id={query.id}
              checked={Enum.member?(@selection, query.id)}
            />
          </:col>
          <:col :let={query} label="preview">
            <.queryt type={query.type} url={query.url} />
          </:col>

          <:col :let={query} label="tags">
            <div class="flex flex-row wrap gap-2">
              <%= for tag <- query.tags do %>
                <div class="p-1 bg-green-100 rounded-lg">
                  <span><%= tag %></span>
                </div>
              <% end %>
            </div>
          </:col>
          <:col :let={query} label="point person">
            <div
              :if={Map.get(query, :assignee, "unassigned")}
              class="p-1 text-green-9f00 w-fit rounded-lg"
            >
              <p><%= Map.get(query, :assignee, "") %></p>
            </div>
          </:col>
          <:col :let={query} label="virality">
            <div class="flex flex-col">
              <p>Exact : <%= query.count.exact %></p>
              <p>Similar : <%= query.count.similar %></p>
            </div>
          </:col>
          <:col :let={query}>
            <div class="flex flex-col gap-2">
              <.link navigate={~p"/demo/query/#{query.id}"}>
                <p class="p-1 bg-yellow-100 text-zinc-800 rounded-md  w-fit">view query</p>
              </.link>
              <.link navigate={~p"/demo/query/verification/#{query.id}"}>
                <p class="p-1 bg-yellow-100 text-zinc-800 rounded-md  w-fit">
                  add verification notes
                </p>
              </.link>
            </div>
          </:col>
        </.table>
      </div>
    </div>
    """
  end

  def mount(params, session, socket) do
    queries = Data.queries()

    socket = socket |> assign(:queries, queries) |> assign(:selection, [])

    {:ok, socket}
  end

  def handle_event("select-one", value, socket) do
    IO.inspect(value)

    selection_type =
      case {} |> Tuple.insert_at(0, value["id"]) |> Tuple.insert_at(1, value["value"]) do
        {_id, nil} -> :subtract
        {_id, _value} -> :add
      end

    IO.inspect(selection_type)

    socket =
      case selection_type == :add && !Enum.member?(socket.assigns.selection, value["value"]) do
        true -> assign(socket, :selection, [value["value"] | socket.assigns.selection])
        false -> socket
      end

    socket =
      case selection_type == :subtract && Enum.member?(socket.assigns.selection, value["id"]) do
        true -> assign(socket, :selection, List.delete(socket.assigns.selection, value["id"]))
        false -> socket
      end

    IO.inspect(socket.assigns.selection)

    {:noreply, socket}
  end

  def handle_event("select-all", value, socket) do
    {:noreply, socket}
  end

  def handle_event("mark-as-spam", value, socket) do
    selection = socket.assigns.selection
    IO.inspect(selection)
    {:noreply, socket}
  end

  def handle_event("delete", value, socket) do
    {:noreply, socket}
  end

  def handle_event("assign-to", value, socket) do
    queries = Data.assign_to(socket.assigns.queries, hd(socket.assigns.selection), value["id"])
    {:noreply, assign(socket, :queries, queries) |> assign(:selection, [])}
  end

  def handle_event("claim", value, socket) do
    queries = Data.assign_to(socket.assigns.queries, hd(socket.assigns.selection), "areeba")
    {:noreply, assign(socket, :queries, queries) |> assign(:selection, [])}
  end

  def handle_params(params, uri, socket) do
    IO.inspect(params)
    {:noreply, socket}
  end
end
