defmodule DAU.FeedFixtures do
  @moduledoc """
  This module defines test helpers for creating entities
  via the `DAU.Feed` context.
  """
  alias DAU.UserMessage.Inbox
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

  def common(%Inbox{} = inbox) do
    Feed.add_to_common_feed(%{
      media_urls: [inbox.file_key],
      media_type: inbox.media_type,
      sender_number: inbox.sender_number,
      language: inbox.user_language_input
    })
  end

  def valid_attributes(_attrs \\ %{}) do
    %{
      "media_urls" => ["temp/audio-01.wav"],
      "media_type" => "audio",
      "sender_number" => "0000000000",
      "verification_note" => "added by dau",
      "tags" => ["politics", "cheapfake"],
      "exact_count" => 0,
      "language" => "en",
      "taken_by" => "dau_sec_1",
      "user_response" => "to be sent to user",
      "verification_sop" => "appears real",
      "verification_status" => "deepfake"
    }
  end

  def common_with_date(attrs \\ %{}) do
    {:ok, common} =
      attrs
      |> Enum.into(%{
        media_urls: ["temp/audio-01.wav"],
        media_type: "audio",
        sender_number: "0000000000",
        language: "en"
      })
      |> Feed.add_to_common_feed_with_timestamp()

    common
  end
end
