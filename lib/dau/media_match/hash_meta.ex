defmodule DAU.MediaMatch.HashMeta do
  alias DAU.Repo
  use Ecto.Schema
  import Ecto.Changeset

  schema "hash_meta" do
    field :count, :integer, default: 0
    field :label, :string
    field :description, :string
    field :value, :string
    field :user_language, Ecto.Enum, values: [:en, :hi, :ta, :te, :und]

    timestamps(type: :utc_datetime)
  end

  def changeset(hash_meta, attrs) do
    hash_meta
    |> cast(attrs, [:count, :label, :description, :value, :user_language])
    |> validate_required([:value, :user_language])
  end
end
