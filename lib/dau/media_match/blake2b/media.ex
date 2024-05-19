defmodule DAU.MediaMatch.Blake2B.Media do
  @moduledoc """
  A media item is uniquely identified with its hash value and
  the language of the user.
  """
  alias DAU.UserMessage.Inbox
  alias DAU.UserMessage.Conversation
  alias DAU.UserMessage
  alias DAU.MediaMatch.HashWorkerResponse
  alias DAU.MediaMatch.Blake2B.Media
  defstruct [:hash, :language, :inbox_id, :count]

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

  def build(attrs) when is_binary(attrs) do
    IO.inspect("here 4")
    IO.inspect(attrs)

    # todo : fix the double decodes.
    with {:ok, temp} <- Jason.decode(attrs),
         {:ok, response_map} <- Jason.decode(temp),
         {:ok, response} <- HashWorkerResponse.new(response_map),
         inbox <- UserMessage.get_incoming_message(response.post_id),
         media <- build(response, inbox) do
      media
    else
      {:error, reason} -> {:error, reason}
    end
  end

  def build(%HashWorkerResponse{} = response, %Inbox{} = inbox) do
    Media.new()
    |> Media.set_inbox_id(response.post_id)
    |> Media.set_hash(response.hash_value)
    |> Media.set_language(inbox.user_language_input)
  end
end
