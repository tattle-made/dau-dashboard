defmodule DAU.MediaMatch.HashWorkerResponse do
  alias DAU.MediaMatch.HashWorkerResponse
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          id: integer(),
          inbox_id: String.t(),
          value: String.t()
        }

  embedded_schema do
    field :inbox_id, :string
    field :value, :string
  end

  def new(attrs \\ %{}) do
    %HashWorkerResponse{}
    |> changeset(attrs)
  end

  def changeset(%HashWorkerResponse{} = response, attrs) do
    response
    |> cast(attrs, [:inbox_id, :value])
    |> validate_required([:inbox_id, :value])
  end
end
