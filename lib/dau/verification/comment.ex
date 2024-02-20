defmodule DAU.Verification.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :content, :map

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content])
    |> validate_required([])
  end
end
