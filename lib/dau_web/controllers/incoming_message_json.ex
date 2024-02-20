defmodule DAUWeb.IncomingMessageJSON do
  alias DAU.UserMessage.IncomingMessage

  @doc """
  Renders a list of incoming_messages.
  """
  def index(%{incoming_messages: incoming_messages}) do
    %{data: for(incoming_message <- incoming_messages, do: data(incoming_message))}
  end

  @doc """
  Renders a single incoming_message.
  """
  def show(%{incoming_message: incoming_message}) do
    %{data: data(incoming_message)}
  end

  defp data(%IncomingMessage{} = incoming_message) do
    %{
      id: incoming_message.id,
      source: incoming_message.source,
      payload_id: incoming_message.payload_id,
      payload_type: incoming_message.payload_type,
      sender_phone: incoming_message.sender_phone,
      sender_name: incoming_message.sender_name,
      context_id: incoming_message.context_id,
      context_gsid: incoming_message.context_gsid,
      payload_text: incoming_message.payload_text,
      payload_caption: incoming_message.payload_caption,
      payload_url: incoming_message.payload_url,
      payload_contenttype: incoming_message.payload_contenttype
    }
  end
end
