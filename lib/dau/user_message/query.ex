defmodule DAU.UserMessage.Query do
  alias DAU.UserMessage.Outbox
  alias DAU.Feed.Common
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_message_query" do
    field :status, Ecto.Enum, values: [:pending, :error, :done, :corrupt]
    belongs_to :feed_common, Common
    belongs_to :user_message_outbox, Outbox, type: :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(query, attrs) do
    query
    |> cast(attrs, [:status])
  end

  def feed_common_changeset(query, %Common{} = feed_common) do
    query
    |> put_assoc(:feed_common, feed_common)
  end

  def associate_outbox(query, %Outbox{} = outbox) do
    query
    |> change()
    |> put_assoc(:user_message_outbox, outbox)
  end
end
