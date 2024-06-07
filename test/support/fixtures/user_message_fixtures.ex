defmodule DAU.UserMessageFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `DAU.UserMessage` context.
  """
  alias DAU.UserMessage

  def get_unique_string(n),
    do: for(_ <- 1..n, into: "", do: <<Enum.random(~c"0123456789abcdef")>>)

  def get_unique_phone_number(),
    do: for(_ <- 1..10, into: "", do: <<Enum.random(~c"0123456789")>>)

  def inbox_message_attrs(media_type, attrs \\ %{})

  def inbox_message_attrs(:video, attrs) do
    %{
      "media_type" => "video",
      "path" => "https://example.com/#{get_unique_string(5)}.mp4",
      "sender_number" => get_unique_phone_number(),
      "sender_name" => get_unique_string(6)
    }
    |> Map.merge(attrs)
  end

  def inbox_message_attrs(:audio, attrs) do
    %{
      "media_type" => "audio",
      "path" => "https://example.com/#{get_unique_string(5)}.wav",
      "sender_number" => get_unique_phone_number(),
      "sender_name" => get_unique_string(6)
    }
    |> Map.merge(attrs)
  end

  @doc """
  Generate a inbox message of video.
  """
  def inbox_video_message_fixture(attrs \\ %{}) do
    {:ok, inbox_video_message} =
      attrs
      |> Enum.into(%{
        media_type: "video",
        path: "https://example.com/video-01.mp4",
        sender_number: "919999999999",
        sender_name: "test_user"
      })
      |> UserMessage.create_incoming_message()

    UserMessage.update_user_message_file_metadata(inbox_video_message, %{
      file_key: "temp/video-01.mp4",
      file_hash: get_unique_string(10)
    })

    inbox_video_message
  end

  def inbox_message_with_date_fixture(attrs \\ %{}) do
    {:ok, inbox_message} =
      attrs
      |> Enum.into(%{
        media_type: "audio",
        path: "temp/audio-01.wav",
        sender_number: "919999999999",
        sender_name: "test_user",
        inserted_at: DateTime.now("Etc/UTC") |> elem(1),
        updated_at: DateTime.now("Etc/UTC") |> elem(1)
      })
      |> UserMessage.create_incoming_message_with_date()

    inbox_message
  end
end
