defmodule DAU.FeedFixtures do
  @moduledoc """
  This module defines test helpers for creating entities
  via the `DAU.Feed` context.
  """
  alias DAU.Feed

  def common_feed_of_five() do
    [
      %{
        media_urls: ["temp/audio-01.wav"],
        media_type: "audio",
        sender_number: "0000000000",
        language: "en"
      },
      %{
        media_urls: ["temp/video-04.mp4"],
        media_type: "video",
        sender_number: "0000000000",
        language: "en"
      },
      %{
        media_urls: ["temp/audio-03.mp4"],
        media_type: "audio",
        sender_number: "0000000000",
        language: "en"
      },
      %{
        media_urls: ["temp/video-02.mp4"],
        media_type: "video",
        sender_number: "0000000000",
        language: "en"
      },
      %{
        media_urls: ["temp/audio-07.wav"],
        media_type: "audio",
        sender_number: "0000000000",
        language: "en"
      }
    ]
    |> Enum.map(&Feed.add_to_common_feed/1)
    |> Enum.map(&elem(&1, 1))
  end

  def common() do
    {:ok, common} =
      %{
        media_urls: ["temp/audio-01.wav"],
        media_type: "audio",
        sender_number: "0000000000",
        language: "en"
      }
      |> Feed.add_to_common_feed()

    common
  end
end
