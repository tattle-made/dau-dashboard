defmodule DAU.UserMessage.Analytics.Event do
  defstruct [:name, :query_id]

  def new() do
    %__MODULE__{}
  end

  def set_name(%__MODULE__{} = event, name) do
    %{event | name: name}
  end

  def set_query_id(%__MODULE__{} = event, query_id) do
    %{event | query_id: query_id}
  end

  def build_from_bsp_delivery_report(params) do
    params = params["_json"]
    params = params |> hd
    event_type = Map.get(params, "eventType", "UNEXPECTED")

    external_id = Map.get(params, "externalId", "ERROR-ERROR")

    length =
      String.split(external_id, "-")
      |> hd
      |> String.length()

    length_plus_one = length + 1
    length_minus_one = length - 1

    _txn_id = String.slice(external_id, 0..length_minus_one)
    msg_id = String.slice(external_id, length_plus_one..-1)

    {:ok, %{msg_id: msg_id, event_type: event_type_atom(event_type)}}

    event_type_atom = event_type_atom(event_type)
    event = event_bsp(event_type_atom, msg_id)
    {:ok, event}
  end

  defp event_type_atom("SUCCESS"), do: :success
  defp event_type_atom("DELIVERED"), do: :delivered
  defp event_type_atom("READ"), do: :read
  defp event_type_atom("FAILED"), do: :failed
  defp event_type_atom(_unexpected), do: :unexpected

  def message_received_by_user_success(common_id) do
    %__MODULE__{
      name: "received_by_user.delivery_report_success",
      query_id: common_id
    }
  end

  def message_received_by_user_failed(common_id) do
    %__MODULE__{
      name: "received_by_user.delivery_report_failed",
      query_id: common_id
    }
  end

  def message_received_by_user_read(common_id) do
    %__MODULE__{
      name: "received_by_user.delivery_report_read",
      query_id: common_id
    }
  end

  def message_received_by_user_delivered(common_id) do
    %__MODULE__{
      name: "received_by_user.delivery_report_delivered",
      query_id: common_id
    }
  end

  def message_received_by_user_unexpected(common_id) do
    %__MODULE__{
      name: "received_by_user.delivery_report_unexpected",
      query_id: common_id
    }
  end

  def message_sent_by_secratariat(query_id) do
    %__MODULE__{
      name: "sent_by_secratariat.user_response",
      query_id: query_id
    }
  end

  def save(%__MODULE__{} = event) do
  end

  def event_dau(:approved_by_secratariat, id), do: Event.message_sent_by_secratariat(id)
  def event_bsp(:success, id), do: Event.message_received_by_user_success(id)
  def event_bsp(:delivered, id), do: Event.message_received_by_user_delivered(id)
  def event_bsp(:read, id), do: Event.message_received_by_user_read(id)
  def event_bsp(:failed, id), do: Event.message_received_by_user_failed(id)
  def event_bsp(:unexpected, id), do: Event.message_received_by_user_unexpected(id)
end
