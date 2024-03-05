defmodule DAUWeb.SearchLive.Index do
  use DAUWeb, :live_view
  use DAUWeb, :html

  @spec render(any()) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <h1 class="text-xl font-normal text-slate-900 mb-2">
      Showing all queries
    </h1>

    <div class="flex flex-col sm:flex-row">
      <div class="h-fit w-full sm:w-1/4 sm:h-auto flex flex-row gap-4 sm:flex-col">
        <div>
          <p class="py-2">Tbd</p>
          <.checkbox label="Unread" checked={true} />
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
            <.checkbox label="Virality" checked={false} />
          </div>
        </div>
      </div>

      <div class="w-full sm:w-3/4">
        <div :if={@selection != []} class="flex flex-row gap-4 align-center ">
          <.action_dropdown />
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
          <:col :let={query} label="assigned to"></:col>
          <:col :let={query} label="tags">
            <div class="flex flex-row wrap gap-2">
              <%= for tag <- query.tags do %>
                <div class="p-1 bg-green-100 rounded-lg">
                  <span><%= tag %></span>
                </div>
              <% end %>
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
                <p class="p-1 bg-green-200 rounded-md  w-fit">view query</p>
              </.link>
              <.link patch={~p"/demo/query/verification/#{query.id}"}>
                <p class="p-1 bg-green-200 rounded-md  w-fit">add verification notes</p>
              </.link>
            </div>
          </:col>
        </.table>
      </div>
    </div>
    """
  end

  def mount(params, session, socket) do
    queries = [
      %{
        id: ~s"asdf",
        type: "video",
        url:
          ~c"https://github.com/tattle-made/feluda/raw/main/src/core/operators/sample_data/sample-cat-video.mp4",
        count: %{exact: 10, similar: 3},
        tags: ["deepfake", "cheapfake", "voiceover"]
      },
      %{
        id: ~s"yuiw",
        type: "audio",
        url: ~c"/assets/audio.wav",
        count: %{exact: 20, similar: 3},
        tags: ["synthetic media", "phase 2", "politics"]
      },
      %{
        id: ~s"pwoe",
        type: "video",
        url:
          ~c"https://github.com/tattle-made/feluda/raw/main/src/core/operators/sample_data/sample-cat-video.mp4",
        count: %{exact: 0, similar: 0},
        tags: ["satire", "spam"]
      },
      %{
        id: ~s"maoq",
        type: "video",
        url:
          ~c"https://github.com/tattle-made/feluda/raw/main/src/core/operators/sample_data/sample-cat-video.mp4",
        count: %{exact: 0, similar: 0},
        tags: ["meme", "spam"]
      }
    ]

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
    # add user in assignees

    {:noreply, assign(socket, :selection, [])}
  end

  def handle_params(params, uri, socket) do
    IO.inspect(params)
    {:noreply, socket}
  end
end
