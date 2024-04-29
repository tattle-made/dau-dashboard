defmodule DAU.MediaMatch.HashWorkerRequest do
  @moduledoc """
  Job description for feluda's hash worker.
  This job is serialized and added to a Queue in RabbitMQ and taken up by feluda workers.
  """
  alias DAU.MediaMatch.HashWorkerRequest
  use Ecto.Schema
  import Ecto.Changeset

  @type media_type :: :video | :audio | :image | :text
  @type t :: %__MODULE__{
          id: String.t(),
          path: String.t(),
          media_type: media_type()
        }

  @primary_key false
  embedded_schema do
    field :id, :string
    field :path, :string
    field :media_type, Ecto.Enum, values: [:video, :audio, :image, :text]
  end

  @all_fields [:id, :path, :media_type]
  @required_fields [:id, :path, :media_type]

  @doc """
  Create a valid job request for hash worker.

  ## Examples
    iex> HashWorkerRequest.new(%{"id" => "123-123-123", "path" => "app/asdf-23", "media_type" => "video"})
    {:ok,
    %DAU.MediaMatch.HashWorkerRequest{
      id: "123-123-123",
      path: "app/asdf-23",
      media_type: :video
    }}

    iex> HashWorkerRequest.new(%{"id" => "123-123-123", "path" => "app/asdf-23", "media_type" => "multimedia"})
    {:error, "Hash worker request is badly formed"}
  """
  @spec new(attrs :: any()) :: {:ok, HashWorkerRequest.t()} | {:error, String.t()}
  def new(attrs \\ %{}) do
    changes = %HashWorkerRequest{} |> changeset(attrs)

    case changes.valid? do
      true -> {:ok, changes |> apply_changes}
      false -> {:error, "Hash worker request is badly formed"}
    end
  end

  def changeset(%HashWorkerRequest{} = request, attrs \\ %{}) do
    request
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
    |> validate_inclusion(:media_type, [:video, :audio, :text, :image])
  end
end
