defmodule DAUWeb.SearchLive.Index do
  use DAUWeb, :live_view
  use DAUWeb, :html

  @spec render(any()) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <h1 class="text-xl font-normal text-slate-900 mb-2">
      Showing all queries
    </h1>
    <div class="w-120 h-fit min-h-60 border-2 border-green-200 p-2 overflow-none">
      <dau-rich-text-editor />
    </div>

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
      <div class="w-full sm:w-3/4 gap-2">
        <.table id="queries" rows={@queries}>
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
          <:col :let={query} label="virality">
            <div class="flex flex-col">
              <p>Exact : <%= query.count.exact %></p>
              <p>Similar : <%= query.count.similar %></p>
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
        id: ~c"asdf",
        type: "video",
        url:
          ~c"https://github.com/tattle-made/feluda/raw/main/src/core/operators/sample_data/sample-cat-video.mp4",
        count: %{exact: 10, similar: 3},
        tags: ["deepfake", "cheapfake", "voiceover"]
      },
      %{
        id: ~c"asdf",
        type: "audio",
        url: ~c"/assets/audio.wav",
        count: %{exact: 20, similar: 3},
        tags: ["synthetic media", "phase 2", "politics"]
      },
      %{
        id: ~c"pwoe",
        type: "video",
        url:
          ~c"https://github.com/tattle-made/feluda/raw/main/src/core/operators/sample_data/sample-cat-video.mp4",
        count: %{exact: 0, similar: 0},
        tags: ["satire", "spam"]
      },
      %{
        id: ~c"maoq",
        type: "video",
        url:
          ~c"https://github.com/tattle-made/feluda/raw/main/src/core/operators/sample_data/sample-cat-video.mp4",
        count: %{exact: 0, similar: 0},
        tags: ["meme", "spam"]
      }
    ]

    {:ok, assign(socket, :queries, queries)}
  end
end
