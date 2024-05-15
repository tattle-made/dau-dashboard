defmodule DAU.MediaMatch.HashWorkerResponse do
  @moduledoc """
  Response returned by hash worker in feluda and added to the report queue.
  """
  alias DAU.MediaMatch.HashWorkerResponse
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          post_id: String.t(),
          hash_value: integer()
        }

  @primary_key false
  embedded_schema do
    field :indexer_id, :integer
    field :post_id, :integer
    field :media_type, :string
    field :hash_value, :string
    field :status, :string
    field :status_code, :integer
  end

  @all_fields [:indexer_id, :post_id, :media_type, :hash_value, :status, :status_code]
  @required_fields [:post_id, :media_type, :hash_value]

  @doc """
  Create a valid response from params.

  Most likely the params will be received from an external response queue like RabbitMQ.

  ## Examples
    iex> HashWorkerResponse.new(%{"post_id" => 1, "hash_value" => "ADFSDFJSKDFJSDKFJKSDSDFSDF" })
    {:ok,
    %DAU.MediaMatch.HashWorkerResponse{
      id: nil,
      post_id: "123-123-sdf",
      hash_value: "ADFSDFJSKDFJSDKFJKSDSDFSDF"
    }}

    iex> HashWorkerResponse.new(%{"value" => "ADFSDFJSKDFJSDKFJKSDSDFSDF" })
    {:error, "Hash worker response is badly formed"}
  """
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
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
  end

  def get_map(%HashWorkerResponse{} = response) do
    Map.take(response, HashWorkerResponse.__schema__(:fields))
  end
end
