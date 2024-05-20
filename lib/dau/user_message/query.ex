defmodule DAU.UserMessage.Query do
  alias DAU.UserMessage.Inbox
  alias DAU.Repo
  alias DAU.UserMessage.Query
  alias DAU.UserMessage.Outbox
  alias DAU.Feed.Common
  use Ecto.Schema
  import Ecto.Changeset

  @derive Jason.Encoder
  schema "user_message_query" do
    field :status, Ecto.Enum, values: [:pending, :error, :done, :corrupt]
    belongs_to :feed_common, Common
    belongs_to :user_message_outbox, Outbox, type: :binary_id
    has_many :messages, Inbox

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(query, attrs \\ %{}) do
    query
    |> cast(attrs, [:status, :inserted_at])
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

  def associate_feed_common_changeset(%Query{} = query, %Common{} = common) do
    Query.changeset(query) |> put_assoc(:feed_common, common) |> IO.inspect()
  end

  @doc """
  Determine which whatsapp business API to use to reply to this query

  Refer to `DAU.UserMessage.Outbox` and field reply_type
  """
  def reply_type(%Query{} = query) do
    received_at = query.inserted_at
    received_at_plus_1_day = DateTime.add(received_at, 60 * 60 * 24, :second)
    {:ok, now} = DateTime.now("Etc/UTC")

    case DateTime.compare(now, received_at_plus_1_day) do
      :gt -> :notification
      :eq -> :notification
      :lt -> :customer_reply
    end
  end

  def get_with_feed_common(query_id) do
    Repo.get(Query, query_id) |> Repo.preload(:feed_common)
  end

  def make_map(%Query{} = query) do
    Map.take(query, Query.__schema__(:fields))
  end
end
