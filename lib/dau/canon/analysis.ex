defmodule DAU.Canon.Analysis do
  use Ecto.Schema
  import Ecto.Changeset

  schema "analysis" do
    field :content, :map

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(analysis, attrs) do
    analysis
    |> cast(attrs, [:content])
    |> validate_required([])
  end
end
