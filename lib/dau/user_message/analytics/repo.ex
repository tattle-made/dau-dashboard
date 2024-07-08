defmodule DAU.UserMessage.Analytics.Repo do
  alias DAU.UserMessage.Analytics.Event, as: AnalyticsEvent
  alias DAU.Repo
  alias DAU.UserMessage.Event
  import Ecto.Query

  def save(%AnalyticsEvent{} = event) do
    attrs = Map.take(event, Event.__schema__(:fields))

    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  def get_by_query_id(query_id) do
    Event
    |> where([e], e.query_id == ^query_id)
    |> Repo.all()
  end
end
