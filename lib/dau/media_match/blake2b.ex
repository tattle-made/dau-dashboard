defmodule DAU.MediaMatch.Blake2B do
  @moduledoc """
  Enforces business logic for hash results from the Python [hash worker](https://github.com/tattle-made/dau-worker).
  """
  require Logger
  alias DAU.Feed.Common
  alias DAU.Feed
  alias DAU.MediaMatch.Blake2b.Match
  alias DAU.UserMessage.Conversation.Hash, as: ConversationHash
  alias DAU.UserMessage.Inbox
  alias DAU.UserMessage.Conversation
  alias DAU.MediaMatch.Hash
  alias DAU.MediaMatch.HashMeta
  alias DAU.MediaMatch.Blake2B.Media
  alias DAU.Repo
  alias Permission
  import Ecto.Query
  import Ecto.Changeset

  @doc """

  args are the args of a `HashResultWorker` job, inserted by the Python hash worker.
  example:  %{"inbox_id" => 1, "media_type" => "video", "hash_value" => "ADFSDFJSKDFJSDKFJKSDSDFSDF", "worker_version" => "blake2b"}

  If the hash does not exist, create a new hashmeta with count set to 1
  if the hash already exists, increment its count by 1

  Runs in one transaction and does nothing when the inbox already has a hash (idempotent).
  """
  def worker_response_received(args) when is_map(args) do
    Repo.transaction(fn ->
      with {:ok, media} <- Media.build(args),
           false <- hash_exists?(media),
           {:ok, _hash} <- save_hash(media),
           {:ok, hashmeta_id} <- increment_hash_count(media),
           {:ok, conversation} <- Conversation.build(media.inbox_id),
           {:ok, _common} <-
             Conversation.associate_hashmeta_with_feed(conversation, hashmeta_id),
           {:ok} <-
             auto_tag_spam(conversation, media) do
        :ok
      else
        true -> :ok
        {:error, reason} -> Repo.rollback(reason)
      end
    end)
  end

  @doc """
  Returns {:ok, hashmeta_id} or {:error, changeset}
  """
  def increment_hash_count(%Media{} = media) do
    case hashmeta_exists?(media) do
      nil ->
        with {:ok, hashmeta} <- save_hashmeta(media) do
          {:ok, hashmeta.id}
        end

      hashmeta ->
        {:ok} = save_hash_count_plus_one(media)
        {:ok, hashmeta.id}
    end
  end

  def hash_exists?(%Media{} = media) do
    Repo.exists?(from(h in Hash, where: h.inbox_id == ^media.inbox_id))
  end

  def hashmeta_exists?(%Media{} = media) do
    Repo.get_by(HashMeta, %{value: media.hash, user_language: media.language})
  end

  def save_hash(%Media{} = media) do
    %Hash{}
    |> Hash.changeset(%{
      value: media.hash,
      inbox_id: media.inbox_id,
      user_language: media.language,
      worker_version: media.worker_version
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

  def get_matches(%Media{} = media) do
    Inbox
    |> join(:left, [i], h in Hash, on: i.id == h.inbox_id)
    |> where([i, h], h.value == ^media.hash)
    |> where([i, h], h.user_language == ^media.language)
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
  rescue
    _ -> nil
  end

  def copy_response_fields(src, target, user) do
    with :ok <- Permission.authorize(user, :edit, Common) do
      src_common = Repo.get(Common, src) |> Repo.preload(:query)

      to_copy = %{
        user_response: src_common.user_response,
        factcheck_articles: src_common.factcheck_articles,
        assessment_report: src_common.assessment_report,
        verification_status: src_common.verification_status
      }

      Repo.get(Common, target)
      |> cast(to_copy, [:user_response, :verification_status])
      |> Repo.update()
    end
  end

  def auto_tag_spam(conversation, media) do
    feed_id = conversation.feed_id
    matches_found = get_matches(media)

    if Enum.any?(matches_found, fn match -> match.verification_status == :spam end) do
      IO.puts("Spam found")
      Feed.change_verification_status_to_spam(feed_id)
      {:ok}
    else
      IO.puts("No spam detected.")
      {:ok}
    end
  end
end
