defmodule DAU.MediaMatch.Blake2B.Media do
  @moduledoc """
  A media item is uniquely identified with its hash value and
  the language of the user.
  """
  alias DAU.UserMessage.Inbox
  alias DAU.UserMessage
  alias DAU.MediaMatch.HashWorkerResponse
  alias DAU.MediaMatch.Blake2B.Media
  defstruct [:hash, :language, :inbox_id, :count, :worker_version]

  def new() do
    %Media{}
  end

  def set_inbox_id(%Media{} = media, inbox_id) do
    %{media | inbox_id: inbox_id}
  end

  def set_hash(%Media{} = media, hash) do
    %{media | hash: hash}
  end

  def set_language(%Media{} = media, language) do
    %{media | language: language}
  end

  def set_count(%Media{} = media, count) do
    %{media | count: count}
  end

  def set_worker_version(%Media{} = media, worker_version) do
    %{media | worker_version: worker_version}
  end

  def build(attrs) when is_map(attrs) do
    with {:ok, response} <- HashWorkerResponse.new(attrs),
         %Inbox{} = inbox <- UserMessage.get_incoming_message(response.inbox_id),
         media <- build(response, inbox) do
      {:ok, media}
    else
      nil -> {:error, :inbox_not_found}
      {:error, _reason} -> {:error, :invalid_args}
    end
  end

  def build(%HashWorkerResponse{} = response, %Inbox{} = inbox) do
    Media.new()
    |> Media.set_inbox_id(response.inbox_id)
    |> Media.set_hash(response.hash_value)
    |> Media.set_language(inbox.user_language_input)
    |> Media.set_worker_version(response.worker_version)
  end
end
