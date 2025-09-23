defmodule DAU.Slack.Channel do
  use Ecto.Schema
  import Ecto.Changeset

  schema "slack_channels" do
    field :channel_id, :string
    field :channel_name, :string

    has_many :messages, DAU.Slack.Message

    timestamps(type: :utc_datetime)
  end

  def changeset(channel, params \\ %{}) do
    channel
    |> cast(params, [:channel_id, :channel_name])
    |> validate_required([:channel_id])
  end
end
