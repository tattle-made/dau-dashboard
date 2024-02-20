defmodule DAU.UserMessageFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `DAU.UserMessage` context.
  """

  @doc """
  Generate a incoming_message.
  """
  def incoming_message_fixture(attrs \\ %{}) do
    {:ok, incoming_message} =
      attrs
      |> Enum.into(%{
        context_gsid: "some context_gsid",
        context_id: "some context_id",
        payload_caption: "some payload_caption",
        payload_contenttype: "some payload_contenttype",
        payload_id: "some payload_id",
        payload_text: "some payload_text",
        payload_type: "some payload_type",
        payload_url: "some payload_url",
        sender_name: "some sender_name",
        sender_phone: "some sender_phone",
        source: "some source"
      })
      |> DAU.UserMessage.create_incoming_message()

    incoming_message
  end
end
