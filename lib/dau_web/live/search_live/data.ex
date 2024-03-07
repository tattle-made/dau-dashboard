defmodule DauWeb.SearchLive.Data do
  def queries() do
    [
      %{
        id: ~s"asdf",
        type: "video",
        url: ~c"/assets/media/video-01.mp4",
        count: %{exact: 10, similar: 3},
        tags: ["deepfake", "cheapfake", "voiceover"]
      },
      %{
        id: ~s"pqmq",
        type: "audio",
        url: ~c"/assets/media/audio-05.wav",
        count: %{exact: 20, similar: 3},
        tags: ["synthetic media", "phase 2", "politics"]
      },
      %{
        id: ~s"yuiw",
        type: "audio",
        url: ~c"/assets/media/audio-01.wav",
        count: %{exact: 20, similar: 3},
        tags: ["synthetic media", "phase 2", "politics"]
      },
      %{
        id: ~s"pwoe",
        type: "video",
        url: ~c"/assets/media/video-04.mp4",
        count: %{exact: 0, similar: 0},
        tags: ["satire", "spam"]
      },
      %{
        id: ~s"twii",
        type: "audio",
        url: ~c"/assets/media/audio-03.wav",
        count: %{exact: 20, similar: 3},
        tags: ["synthetic media", "phase 2", "politics"]
      },
      %{
        id: ~s"maoq",
        type: "video",
        url: ~c"/assets/media/video-09.mp4",
        count: %{exact: 0, similar: 0},
        tags: ["meme", "spam"]
      }
    ]
  end

  def assign_to(queries, query_id, assignee) do
    queries
    |> Enum.map(fn query ->
      if query.id == query_id, do: Map.put(query, :assignee, assignee), else: query
    end)
  end

  def search_filter() do
    [%{feed: ~c""}]
  end
end
