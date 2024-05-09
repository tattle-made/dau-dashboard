defmodule DAU.MediaMatch.HashMeta do
  use Ecto.Schema
  import Ecto.Changeset

  schema "hash_meta" do
    field :count, :integer
    field :label, :string
    field :description, :string
    field :value, :string
    field :user_language, Ecto.Enum, values: [:en, :hi, :ta, :te, :und]

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(hash_meta, attrs) do
    hash_meta
    |> cast(attrs, [:count, :label, :description])
    |> validate_required([:count, :label, :description])
  end
end
