defmodule DAU.Slack.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "slack_messages" do
    field :ts, :string
    field :team, :string
    field :user, :string
    field :text, :string
    field :urls, {:array, :string}
    field :is_deleted, :boolean, default: false
    field :is_edited, :boolean, default: false

    belongs_to :channel, DAU.Slack.Channel
    belongs_to :parent, DAU.Slack.Message
    has_many :thread_messages, DAU.Slack.Message, foreign_key: :parent_id
    embeds_many :files, DAU.Slack.File, on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  def changeset(message, params \\ %{}) do
    message
    |> cast(params, [:ts, :team, :channel_id, :user, :text, :urls, :parent_id, :is_deleted, :is_edited])
    |> cast_embed(:files)
    |> validate_required([:ts, :team, :channel_id, :user])
    |> assoc_constraint(:channel)
    |> foreign_key_constraint(:parent_id)
    |> unique_constraint(:ts, name: :slack_messages_team_channel_ts_index)
  end
end
