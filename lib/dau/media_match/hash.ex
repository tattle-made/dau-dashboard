defmodule DAU.MediaMatch.Hash do
  alias DAU.UserMessage.Inbox
  use Ecto.Schema
  import Ecto.Changeset

  schema "hashes" do
    field :value, :string
    field :worker_version, :string
    field :user_language, Ecto.Enum, values: [:en, :hi, :ta, :te, :ur, :und]
    belongs_to :inbox, Inbox

    timestamps(type: :utc_datetime)
  end

  def changeset(hash, attrs) do
    hash
    |> cast(attrs, [:value, :worker_version, :inbox_id, :user_language])
    |> validate_required([:value, :inbox_id, :user_language])
    |> foreign_key_constraint(:inbox_id)
  end
end
