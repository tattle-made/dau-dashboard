defmodule DAU.MediaMatch.Blake2B do
  @moduledoc """
  Enforces business logic for Feluda [hash worker](https://github.com/tattle-made/feluda/tree/main/src/worker/hash).


  """
  require Logger
  alias DAU.Feed.Common
  alias DAU.MediaMatch.Blake2b.Match
  alias DAU.UserMessage.Conversation.Hash, as: ConversationHash
  alias DAU.UserMessage
  alias DAU.UserMessage.Inbox
  alias DAU.UserMessage.Conversation
  alias DAU.UserMessage.Conversation.MessageAdded
  alias DAU.MediaMatch.Hash
  alias DAU.MediaMatch.HashMeta
  alias DAU.MediaMatch.HashWorkerGenServer
  alias DAU.MediaMatch.HashWorkerResponse
  alias DAU.MediaMatch.Blake2b.WorkerRequest
  alias DAU.MediaMatch.Blake2B.Media
  alias DAU.Repo
  import Ecto.Query
  import Ecto.Changeset

  @doc """

  response is unstructured data received from a rabbitmq queue
  example:  %{"post_id" => 1, "hash_value" => "ADFSDFJSKDFJSDKFJKSDSDFSDF" }

  If the hash does not exist, create a new hashmeta with count set to 1
  if the hash already exists, increment its count by 1
  """
  def worker_response_received(response_string) do
    with media <- Media.build(response_string) |> IO.inspect(),
         {:ok, _hash} <- save_hash(media) |> IO.inspect(),
         {:ok, hashmeta_id} <- increment_hash_count(media) |> IO.inspect(),
         {:ok, conversation} <- Conversation.build(media.inbox_id) |> IO.inspect(),
         {:ok, _common} <-
           Conversation.associate_hashmeta_with_feed(conversation, hashmeta_id) |> IO.inspect() do
      :ok
    else
      err ->
        Logger.info("here 1")
        Logger.error(err)
        err
    end
  rescue
    error ->
      IO.inspect(error)
      Logger.info("here 2")
      Logger.error(error)
      # Sentry.capture_exception(error, stacktrace: __STACKTRACE__)
  end

  @doc """

  Returns {:ok, hashmeta} or {:ok}
  """
  def increment_hash_count(%Media{} = media) do
    case hashmeta_exists?(media) do
      nil ->
        {:ok, hashmeta} = save_hashmeta(media)
        {:ok, hashmeta.id}

      hashmeta ->
        {:ok} = save_hash_count_plus_one(media)
        {:ok, hashmeta.id}
    end
  end

  def hashmeta_exists?(%Media{} = media) do
    Repo.get_by(HashMeta, %{value: media.hash, user_language: media.language})
  end

  def save_hash(%Media{} = media) do
    %Hash{}
    |> Hash.changeset(%{
      value: media.hash,
      inbox_id: media.inbox_id,
      user_language: media.language
    })
    |> Repo.insert()
  end

  def save_hashmeta(%Media{} = media) do
    %HashMeta{}
    |> HashMeta.changeset(%{value: media.hash, user_language: media.language, count: 1})
    |> Repo.insert()
  end

  def get_hashmeta!(id), do: Repo.get!(HashMeta, id)

  @doc """

  """
  def save_hash_count_plus_one(%Media{} = media) do
    {_num, _result} =
      HashMeta
      |> where(value: ^media.hash)
      |> where(user_language: ^media.language)
      |> Repo.update_all(inc: [count: 1])

    {:ok}
  end

  def create_job(%MessageAdded{} = request) do
    HashWorkerGenServer.add_to_job_queue(HashWorkerGenServer, request)
  end

  def get_matches(%Hash{} = hash) do
    conversation_hash = hash |> ConversationHash.new()

    get_matches(conversation_hash)
  end

  def get_matches(%ConversationHash{} = conversation_hash) do
    Inbox
    |> join(:left, [i], h in Hash, on: i.id == h.inbox_id)
    |> where([i, h], h.value == ^conversation_hash.value)
    |> where([i, h], h.user_language == ^conversation_hash.language)
    |> Repo.all()
    |> Enum.map(&(Conversation.build(&1.id) |> elem(1)))
    |> Enum.map(&Match.new(&1))
  end

  def get_matches_by_common_id(common_id) do
    Repo.get(Common, common_id)
    |> Repo.preload(query: [:feed_common, :user_message_outbox, messages: [:hash]])
    |> Map.get(:query)
    |> Map.get(:messages)
    |> hd
    |> Map.get(:hash)
    |> ConversationHash.new()
    |> get_matches()
    |> then(fn matches ->
      %{count: length(matches), result: matches}
    end)
  end

  def copy_response_fields(src, target) do
    src_common = Repo.get(Common, src) |> Repo.preload(:query)

    to_copy = %{
      user_response: src_common.user_response,
      factcheck_articles: src_common.factcheck_articles,
      assessment_report: src_common.assessment_report,
      verification_status: src_common.verification_status
    }

    new_target =
      Repo.get(Common, target)
      |> cast(to_copy, [:user_response, :verification_status])
      |> Repo.update()

    new_target
  end
end
