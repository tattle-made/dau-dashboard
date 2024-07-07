defmodule DAU.UserMessage.Analytics.Repo do
  alias DAU.UserMessage.Analytics.Event, as: AnalyticsEvent
  alias DAU.Repo
  alias DAU.UserMessage.Event

  def save(%AnalyticsEvent{} = event) do
    attrs = Map.take(event, Event.__schema__(:fields))

    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end
end
