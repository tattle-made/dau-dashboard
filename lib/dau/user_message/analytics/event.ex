defmodule DAU.UserMessage.Analytics.Event do
  alias DAU.UserMessage.Event
  alias DAU.Repo
  alias DAU.UserMessage.Analytics.DeliveryReport

  defstruct [:name, :query_id]

  def save(%__MODULE__{} = event) do
    %Event{name: event.name, query_id: event.query_id}
    |> Repo.insert()
    |> IO.inspect(label: "save result")
  end

  # def event_dau(:approved_by_secratariat, id), do: Event.message_sent_by_secratariat(id)

  def event_bsp(%DeliveryReport{} = delivery_report, query_id) do
    event =
      %__MODULE__{
        name: DeliveryReport.event_name(delivery_report),
        query_id: query_id
      }

    {:ok, event}
  end
end
