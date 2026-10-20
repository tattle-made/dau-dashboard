defmodule DAU.MediaMatch do
  @moduledoc """
  The MediaMatching context. Helps in managing operations on exact or similar media items.

  For every media item received in the dau inbox, `create_job/2` inserts a hash request job for the hash worker. Its result arrives as a `HashResultWorker` job, which updates the hash and duplicate tables. All data useful for media matching should be in our database by then.

  Now for higher level media matching features, look in other contexts like `UserMessage` or SpamFilter
  """

  import Ecto.Query, warn: false
  alias DAU.MediaMatch.HashMeta
  alias DAU.MediaMatch.Hash
  alias DAU.MediaMatch.HashWorkerRequest
  alias DAU.UserMessage.Conversation.MessagePropertiesAdded
  alias DAU.UserMessage.Inbox
  alias DAU.Repo

  @hash_queue "media_hash"
  @hash_worker "dau_worker.hash_worker.HashWorker"

  @doc """
  Insert a hash request job for the Python hash worker. At most one incomplete job exists per inbox.
  """
  @spec create_job(Inbox.t() | MessagePropertiesAdded.t(), :hash_worker) ::
          {:ok, Oban.Job.t()} | {:error, term()}
  def create_job(inbox_or_message, :hash_worker) do
    with {:ok, request} <- HashWorkerRequest.new(inbox_or_message) do
      request
      |> HashWorkerRequest.to_args()
      |> Oban.Job.new(
        queue: @hash_queue,
        worker: @hash_worker,
        max_attempts: 5,
        unique: [period: :infinity, keys: [:inbox_id], states: :incomplete]
      )
      |> Oban.insert()
    end
  end

  @doc """
  Create a row in mediamatch_hashes table.
  """
  def create_hash(attrs) do
    %Hash{}
    |> Hash.changeset(attrs)
    |> Repo.insert()
  end

  def create_hashmeta(attrs) do
    %HashMeta{}
    |> HashMeta.changeset(attrs)
    |> Repo.insert()
  end

  def get_hashmeta(value, user_language) do
    Repo.get_by(HashMeta, %{value: value, user_language: user_language})
  end
end
