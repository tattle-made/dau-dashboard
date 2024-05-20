defmodule DAU.MediaMatch do
  @moduledoc """
  The MediaMatching context. Helps in managing operations on exact or similar media items.

  For every media item that is received in the dau inbox, a job is created using `create_job/2`.
  The job could be created in db, in memory or in a queue like RabbitMQ. That is controlled by the :via option of `create_job/2`. At some point Dashboard receives a `HashWorkerResponse`
  which is used to update the duplicate table for the corresponding inbox media item using `create_duplicate/1`
  This marks the end of the processing pipeline. All data useful for media matching should be in our database by now.

  Now for higher level media matching features, look in other contexts like `UserMessage` or SpamFilter
  """

  import Ecto.Query, warn: false
  alias DAU.MediaMatch.HashMeta
  alias DAU.MediaMatch.Hash
  alias DAU.MediaMatch.HashWorkerResponse
  alias DAU.UserMessage.Inbox
  alias DAU.Repo
  import Ecto.Query

  @type create_job_option :: {:via, :rabbitmq | :memory}
  @type create_job_options :: [create_job_option()]

  @spec create_job(Inbox.t(), :hash_worker | :vector_worker, create_job_options()) ::
          {:ok} | {:ok, response: HashWorkerResponse.t()} | {:error, reason: String.t()}
  def create_job(%Inbox{} = _inbox, :hash_worker, opts) do
    via = Keyword.get(opts, :via, :memory)

    case via do
      :rabbitmq ->
        {:ok}

      _ ->
        raise "Unsupported value for via : #{inspect(via)}"
    end
  end

  def create_job(%Inbox{} = _inbox, :vector_worker, opts) do
    via = Keyword.get(opts, :via, :memory)

    case via do
      :rabbitmq -> nil
      :memory -> nil
      _ -> raise "Unsupported value for via : #{inspect(via)}"
    end
  end

  def create_duplicate(%HashWorkerResponse{}) do
  end

  @doc """
  Create a row in mediamatch_hashes table.
  """
  def create_hash(%HashWorkerResponse{} = response, %Inbox{} = inbox) do
    attrs = HashWorkerResponse.get_map(response)
    attrs |> Map.put(:user_language, inbox.user_language_input)

    create_hash(attrs)
  end

  def create_hash(attrs) do
    %Hash{}
    |> Hash.changeset(attrs)
    |> Repo.insert()
  end

  # def create_hashmeta(%HashWorkerResponse{} = response, %Inbox{} = inbox) do
  #   create_hashmeta
  # end

  def create_hashmeta(attrs) do
    %HashMeta{}
    |> HashMeta.changeset(attrs)
    |> Repo.insert()
  end

  def get_hashmeta(value, user_language) do
    Repo.get_by(HashMeta, %{value: value, user_language: user_language})
  end

  @doc """
  Given hash value, get inbox.query.common

  This can then be used to answer the following queries :
  1. Find response to media with hash h
  """
  def get_inbox_by_hash(hash, opts \\ []) do
    preload = Keyword.get(opts, :preload, false)

    preload_statement = fn query ->
      if preload, do: Repo.preload(query, inbox: [query: [:feed_common]]), else: query
    end

    from(h in Hash, where: h.value == ^hash)
    |> limit(1)
    |> Repo.all()
    |> preload_statement.()
    |> hd
    |> Map.get(:inbox)
  end

  @doc """
  Get user response associated with a media item.
  """
  def get_user_response_by_hash(%Hash{} = hash) do
    inbox = get_inbox_by_hash(hash.value)
    inbox.query.feed_common.user_response
  end

  def get_user_response_by_hash(%HashWorkerResponse{} = hash) do
    inbox = get_inbox_by_hash(hash.value)
    inbox.query.feed_common.user_response
  end

  def increment_hash_count(value, language) do
    HashMeta
    |> where(value: ^value)
    |> where(user_language: ^language)
    |> Repo.update_all(inc: [count: 1])
  end
end
