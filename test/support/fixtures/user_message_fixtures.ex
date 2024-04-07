defmodule DAU.UserMessageFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `DAU.UserMessage` context.
  """
  alias DAU.UserMessage

  @doc """
  Generate a inbox message of a video.
  """
  def inbox_video_message_fixture(attrs \\ %{}) do
    {:ok, inbox_video_message} =
      attrs
      |> Enum.into(%{
        media_type: "video",
        path: "temp/audio-01.wav",
        sender_number: "919999999999",
        sender_name: "test_user"
      })
      |> UserMessage.create_incoming_message()

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
