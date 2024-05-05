defmodule DAU.MediaMatch.Hash do
  alias DAU.UserMessage.Inbox
  use Ecto.Schema
  import Ecto.Changeset

  schema "mediamatch_hashes" do
    field :value, :string
    field :worker_version, :string
    belongs_to :inbox, Inbox

    timestamps(type: :utc_datetime)
  end

  def changeset(hash, attrs) do
    hash
    |> cast(attrs, [:value, :worker_version, :inbox_id])
    |> validate_required([:value, :inbox_id])
    |> foreign_key_constraint(:inbox_id)
  end
end
