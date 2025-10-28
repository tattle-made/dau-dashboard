defmodule DAU.Slack.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "slack_events" do
    field :event_id, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(event, params \\ %{}) do
    event
    |> cast(params, [:event_id])
    |> validate_required([:event_id])
  end
end
