defmodule DAU.Verification.Response do
  use Ecto.Schema
  import Ecto.Changeset

  schema "responses" do
    field :content, :map

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(response, attrs) do
    response
    |> cast(attrs, [:content])
    |> validate_required([])
  end
end
