defmodule DAU.MediaMatch.HashWorkerResponse do
  @moduledoc """
  Response returned by hash worker in feluda and added to the report queue.
  """
  alias DAU.MediaMatch.HashWorkerResponse
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          inbox_id: String.t(),
          value: String.t()
        }

  @primary_key false
  embedded_schema do
    field :inbox_id, :string
    field :value, :string
  end

  @doc """
  Create a valid response from params.

  Most likely the params will be received from an external response queue like RabbitMQ.

  ## Examples
    iex> {HashWorkerResponse.new(%{"inbox_id" => "123-123-sdf", "value" => "ADFSDFJSKDFJSDKFJKSDSDFSDF" })}
    {:ok,
    %DAU.MediaMatch.HashWorkerResponse{
      id: nil,
      inbox_id: "123-123-sdf",
      value: "ADFSDFJSKDFJSDKFJKSDSDFSDF"
    }}

    iex> HashWorkerResponse.new(%{"value" => "ADFSDFJSKDFJSDKFJKSDSDFSDF" })
    {:error, "Hash worker response is badly formed"}
  """
  def new(attrs) when is_binary(attrs) do
    Jason.decode!(attrs)
    |> new()
  end

  @spec new(attrs :: any()) :: {:ok, HashWorkerResponse.t()} | {:error, String.t()}
  def new(attrs) when is_map(attrs) do
    changes = %HashWorkerResponse{} |> changeset(attrs)

    case changes.valid? do
      true -> {:ok, changes |> apply_changes}
      false -> {:error, "Hash worker response is badly formed"}
    end
  end

  def changeset(%HashWorkerResponse{} = response, attrs) do
    response
    |> cast(attrs, [:inbox_id, :value])
    |> validate_required([:inbox_id, :value])
  end

  def get_map(%HashWorkerResponse{} = response) do
    Map.take(response, HashWorkerResponse.__schema__(:fields))
  end
end
