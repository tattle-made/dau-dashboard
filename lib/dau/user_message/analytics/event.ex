defmodule DAU.UserMessage.Analytics.Event do
  defstruct [:name, :query_id]

  def new() do
    %__MODULE__{}
  end

  def set_name(%__MODULE__{} = event, name) do
    %{event | name: name}
  end

  def message_received_by_user_success(common_id) do
    %__MODULE__{
      name: "received_by_user.delivery_report_success",
      query_id: query_id
    }
  end

  def message_received_by_user_failure(common_id) do
    %__MODULE__{
      name: "received_by_user.delivery_report_failure",
      query_id: query_id
    }
  end

  def message_received_by_user_read(common_id) do
    %__MODULE__{
      name: "received_by_user.delivery_report_read",
      query_id: query_id
    }
  end

  def message_received_by_user_delivered(common_id) do
    %__MODULE__{
      name: "received_by_user.delivery_report_delivered",
      query_id: query_id
    }
  end

  def message_sent_by_secratariat(query_id) do
    %__MODULE__{
      name: "sent_by_secratariat.user_response",
      query_id: query_id
    }
  end
end
