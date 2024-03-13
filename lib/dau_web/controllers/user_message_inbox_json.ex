defmodule DAUWeb.IncomingMessageJSON do
  alias DAU.UserMessage.Inbox

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

  defp data(%Inbox{} = incoming_message) do
    %{
      id: incoming_message.id,
      mobile: incoming_message.mobile,
      name: incoming_message.name,
      type: incoming_message.type,
      timestamp: incoming_message.timestamp
    }
  end
end
