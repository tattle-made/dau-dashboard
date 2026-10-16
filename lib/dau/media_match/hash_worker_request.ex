defmodule DAU.MediaMatch.HashWorkerRequest do
  @moduledoc """
  Arguments of the hash request job inserted on the `media_hash` Oban queue.
  """
  alias DAU.UserMessage.Inbox
  alias DAU.UserMessage.Conversation.MessagePropertiesAdded
  alias DAU.MediaMatch.HashWorkerRequest
  use Ecto.Schema
  import Ecto.Changeset

  @type media_type :: :video | :audio | :image | :text
  @type t :: %__MODULE__{
          inbox_id: integer(),
          file_key: String.t(),
          media_type: media_type()
        }

  @primary_key false
  @derive Jason.Encoder
  embedded_schema do
    field :inbox_id, :integer
    field :file_key, :string
    field :media_type, Ecto.Enum, values: [:video, :audio, :image, :text]
  end

  @all_fields [:inbox_id, :file_key, :media_type]
  @required_fields [:inbox_id, :file_key, :media_type]

  @doc """
  Create a valid job request for hash worker.

  ## Examples
    iex> HashWorkerRequest.new(%{"inbox_id" => 123, "file_key" => "app/asdf-23", "media_type" => "video"})
    {:ok,
    %DAU.MediaMatch.HashWorkerRequest{
      inbox_id: 123,
      file_key: "app/asdf-23",
      media_type: :video
    }}

    iex> HashWorkerRequest.new(%{"inbox_id" => 123, "file_key" => "app/asdf-23", "media_type" => "multimedia"})
    {:error, "Hash worker request is badly formed"}
  """
  @spec new(attrs :: any()) :: {:ok, HashWorkerRequest.t()} | {:error, String.t()}
  def new(%Inbox{} = inbox) do
    new(%{inbox_id: inbox.id, file_key: inbox.file_key, media_type: inbox.media_type})
  end

  def new(%MessagePropertiesAdded{} = message) do
    new(%{inbox_id: message.id, file_key: message.path, media_type: message.media_type})
  end

  def new(attrs) do
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

  def to_args(%HashWorkerRequest{} = request) do
    %{
      inbox_id: request.inbox_id,
      file_key: request.file_key,
      media_type: Atom.to_string(request.media_type)
    }
  end
end
