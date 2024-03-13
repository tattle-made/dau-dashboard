defmodule DauWeb.SearchLive.Data do
  def queries() do
    [
      %{
        id: 1,
        type: "video",
        url: ~c"/assets/media/video-01.mp4",
        count: %{exact: 10, similar: 3},
        inserted_at: ~D[2024-03-01],
        tags: ["deepfake", "cheapfake", "voiceover"]
      },
      %{
        id: 2,
        type: "audio",
        url: ~c"/assets/media/audio-05.wav",
        count: %{exact: 20, similar: 3},
        inserted_at: ~D[2024-03-03],
        tags: ["synthetic media", "phase 2", "politics"]
      },
      %{
        id: 3,
        type: "audio",
        url: ~c"/assets/media/audio-01.wav",
        count: %{exact: 20, similar: 3},
        inserted_at: ~D[2024-03-04],
        tags: ["synthetic media", "phase 2", "politics"]
      },
      %{
        id: 4,
        type: "video",
        url: ~c"/assets/media/video-04.mp4",
        count: %{exact: 0, similar: 0},
        inserted_at: ~D[2024-03-05],
        tags: ["satire", "spam"]
      },
      %{
        id: 5,
        type: "audio",
        url: ~c"/assets/media/audio-03.wav",
        count: %{exact: 20, similar: 3},
        inserted_at: ~D[2024-03-07],
        tags: ["synthetic media", "phase 2", "politics"]
      },
      %{
        id: 6,
        type: "video",
        url: ~c"/assets/media/video-09.mp4",
        inserted_at: ~D[2024-03-08],
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
