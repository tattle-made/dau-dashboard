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
        path: "https://file-url.com",
        sender_number: "9999999999",
        sender_name: "tattle_tester"
      })
      |> UserMessage.create_incoming_message()

    inbox_video_message
  end
end
