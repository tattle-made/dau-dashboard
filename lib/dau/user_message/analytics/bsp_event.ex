defmodule DAU.UserMessage.Analytics.BSPEvent do
  @moduledoc """
  Create `Event` structs for events emitted by the BSP
  """
  alias DAU.UserMessage.Analytics.Event

  def message_received_by_user_success(query_id) do
    %Event{
      name: "event.bsp.message_delivery_success",
      query_id: query_id
    }
  end

  def message_received_by_user_failed(query_id) do
    %Event{
      name: "event.bsp.message_delivery_failed",
      query_id: query_id
    }
  end

  def message_received_by_user_read(query_id) do
    %Event{
      name: "event.bsp.message_read",
      query_id: query_id
    }
  end

  def message_received_by_user_delivered(query_id) do
    %Event{
      name: "event.bsp.message_delivered",
      query_id: query_id
    }
  end

  def message_received_by_user_unexpected(query_id) do
    %Event{
      name: "event.bsp.unexpected_delivery_report",
      query_id: query_id
    }
  end

  def event(:success, id), do: message_received_by_user_success(id)
  def event(:delivered, id), do: message_received_by_user_delivered(id)
  def event(:read, id), do: message_received_by_user_read(id)
  def event(:failed, id), do: message_received_by_user_failed(id)
  def event(:unexpected, id), do: message_received_by_user_unexpected(id)
end
