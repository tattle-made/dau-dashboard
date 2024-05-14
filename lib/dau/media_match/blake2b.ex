defmodule DAU.MediaMatch.Blake2B do
  @moduledoc """
  Enforces business logic for Feluda [hash worker](https://github.com/tattle-made/feluda/tree/main/src/worker/hash).

  """
  require Logger
  alias DAU.MediaMatch.Hash
  alias DAU.Repo
  alias DAU.MediaMatch.HashMeta
  alias DAU.UserMessage.Inbox
  alias DAU.MediaMatch
  alias DAU.UserMessage
  alias DAU.MediaMatch.HashWorkerResponse
  alias DAU.MediaMatch.Blake2B.Media
  import Ecto.Query

  def build(hashworker_response_attrs) do
    {:ok, hash_worker_response} = HashWorkerResponse.new(hashworker_response_attrs)
    %Inbox{} = inbox = UserMessage.get_incoming_message!(hash_worker_response.post_id)

    Media.build()
    |> Media.set_inbox_id(hash_worker_response.post_id)
    |> Media.set_hash(hash_worker_response.hash_value)
    |> Media.set_language(inbox.user_language_input)
  end

  @doc """

  response is unstructured data received from a rabbitmq queue
  example:  %{"post_id" => 1, "hash_value" => "ADFSDFJSKDFJSDKFJKSDSDFSDF" }
  """
  def worker_response_received(response) do
    with media <- build(response),
         {:ok, hash} <- save_hash(media),
         {:ok, hashmeta} <- increment_hash_count(media) do
      {:ok, {hash, hashmeta}}
    else
      err -> err
    end
  rescue
    error ->
      Logger.error(error)
      Sentry.capture_exception(error, stacktrace: __STACKTRACE__)
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
    |> HashMeta.changeset(%{value: media.hash, user_language: media.language})
    |> Repo.insert()
  end

  def save_hash_count_plus_one(%Media{} = media) do
    {num, result} =
      HashMeta
      |> where(value: ^media.hash)
      |> where(user_language: ^media.language)
      |> Repo.update_all(inc: [count: 1])

    {:ok}
  end
end
