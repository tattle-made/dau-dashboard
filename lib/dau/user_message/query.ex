defmodule DAU.UserMessage.Query do
  alias DAU.UserMessage.Outbox
  alias DAU.Feed.Common
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_message_query" do
    field :status, Ecto.Enum, values: [:pending, :error, :done, :corrupt]
    belongs_to :feed_common_id, Common
    belongs_to :user_message_outbox_id, Outbox

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(query, attrs) do
    query
    |> cast(attrs, [:status])
    |> validate_required([:status])
  end
end
