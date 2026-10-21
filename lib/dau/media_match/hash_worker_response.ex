defmodule DAU.MediaMatch.HashWorkerResponse do
  @moduledoc """
  Response returned by oban hash worker. The response ends up enqueued as a job for `HashResultWorker`.
  """
  alias DAU.MediaMatch.HashWorkerResponse
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          indexer_id: integer() | nil,
          inbox_id: integer(),
          media_type: String.t(),
          hash_value: String.t(),
          status: String.t() | nil,
          status_code: integer() | nil,
          worker_version: String.t() | nil
        }

  @primary_key false
  embedded_schema do
    field :indexer_id, :integer
    field :inbox_id, :integer
    field :media_type, :string
    field :hash_value, :string
    field :status, :string
    field :status_code, :integer
    field :worker_version, :string
  end

  @all_fields [
    :indexer_id,
    :inbox_id,
    :media_type,
    :hash_value,
    :status,
    :status_code,
    :worker_version
  ]
  @required_fields [:inbox_id, :media_type, :hash_value]

  @doc """
  Create a valid response from params.

  Most likely the params are the args of a `HashResultWorker` job, inserted by the hash worker.

  ## Examples
    iex> HashWorkerResponse.new(%{"inbox_id" => 1, "media_type" => "video", "hash_value" => "AACAPwAAAEAAAEBA", "worker_version" => "feluda-video-hash@0.1.1"})
    {:ok,
    %DAU.MediaMatch.HashWorkerResponse{
      inbox_id: 1,
      media_type: "video",
      hash_value: "AACAPwAAAEAAAEBA",
      worker_version: "feluda-video-hash@0.1.1"
    }}

    iex> HashWorkerResponse.new(%{"inbox_id" => 1, "media_type" => "video"})
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
end
