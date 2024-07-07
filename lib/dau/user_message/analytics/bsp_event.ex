defmodule DAU.UserMessage.Analytics.BSPEvent do
  @moduledoc """
  Create `Event` structs for events emitted by the BSP
  """
  alias DAU.UserMessage.Analytics.Event

  def message_received_by_user_success(common_id) do
    %Event{
      name: "received_by_user.delivery_report_success",
      query_id: common_id
    }
  end

  def message_received_by_user_failed(common_id) do
    %Event{
      name: "received_by_user.delivery_report_failed",
      query_id: common_id
    }
  end

  def message_received_by_user_read(common_id) do
    %Event{
      name: "received_by_user.delivery_report_read",
      query_id: common_id
    }
  end

  def message_received_by_user_delivered(common_id) do
    %Event{
      name: "received_by_user.delivery_report_delivered",
      query_id: common_id
    }
  end

  def message_received_by_user_unexpected(common_id) do
    %Event{
      name: "received_by_user.delivery_report_unexpected",
      query_id: common_id
    }
  end

  def event(:success, id), do: message_received_by_user_success(id)
  def event(:delivered, id), do: message_received_by_user_delivered(id)
  def event(:read, id), do: message_received_by_user_read(id)
  def event(:failed, id), do: message_received_by_user_failed(id)
  def event(:unexpected, id), do: message_received_by_user_unexpected(id)
end
