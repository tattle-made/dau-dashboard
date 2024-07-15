defmodule DAU.UserMessage.Event do
  alias DAU.UserMessage.Event
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_message_event" do
    field :name, :string
    field :query_id, :id
    field :timestamp, :utc_datetime, virtual: true

    timestamps(type: :utc_datetime)
  end

  def timestamp(%Event{inserted_at: inserted_at} = event) do
    %Event{event | timestamp: inserted_at}
  end

  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :query_id])
    |> validate_required([:name, :query_id])
  end
end
