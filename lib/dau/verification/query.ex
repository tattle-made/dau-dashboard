defmodule DAU.Verification.Query do
  use Ecto.Schema
  import Ecto.Changeset

  schema "queries" do
    field :messages, {:array, :string}
    field :status, :string
    field :response, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(query, attrs) do
    query
    |> cast(attrs, [:messages, :status])
    |> validate_required([:messages, :status])
  end
end
