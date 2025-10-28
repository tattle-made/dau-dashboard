defmodule DAU.Slack.SlackEvent do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :event_type, :string
    field :event_subtype, :string, default: nil
    field :event_deleted_ts, :string, default: nil
    field :previous_message, :map, default: nil
    field :thread_ts, :string, default: nil
    field :channel, :string, default: nil
    field :ts, :string
    field :ts_utc, :utc_datetime_usec
    field :user, :string, default: nil
    field :text, :string, default: nil

    embeds_one :event_message, EventMessage, primary_key: false do
      field :message_ts, :string
      field :message_text, :string, default: nil
      field :message_subtype, :string, default: nil
      field :message_edited, :map, default: nil
      field :message_thread_ts, :string, default: nil
    end
  end

  def changeset(%__MODULE__{} = slack_event, attrs \\ %{}) do
    slack_event
    |> cast(attrs, [
      :event_type,
      :event_subtype,
      :event_deleted_ts,
      :previous_message,
      :thread_ts,
      :channel,
      :ts,
      :ts_utc,
      :user,
      :text
    ])
    |> validate_required([:ts,:ts_utc, :channel])
    |> cast_embed(:event_message, with: &event_message_changeset/2)
  end

  defp event_message_changeset(schema, params) do
    schema
    |> cast(params, [
      :message_ts,
      :message_text,
      :message_subtype,
      :message_edited,
      :message_thread_ts
    ])
    |> validate_required([:message_ts])
  end

  @doc """
  Builds a new Slack event struct with the given attributes.
  """

  def new(attrs \\ %{}) do
    %__MODULE__{}
    |> changeset(attrs)
    |> apply_action(:insert)
  end
end
