defmodule DAU.UserMessage.Analytics.DAUEvent do
  @moduledoc """
  Create `Event` structs for events related to DAU secratariat functions
  """
  alias DAU.UserMessage.Analytics.Event

  def message_sent_by_secratariat!(query_id) do
    %Event{
      name: "message_sent_by_secratariat.user_response",
      query_id: query_id
    }
  end

  def message_approved_by_secratariat!(query_id) do
    %Event{
      name: "message_approved_by_secratariat.user_response",
      query_id: query_id
    }
  end

  def event(:message_sent_by_secratariat, id), do: message_sent_by_secratariat!(id)
  def event(:message_approved_by_secratariat, id), do: message_approved_by_secratariat!(id)
end
