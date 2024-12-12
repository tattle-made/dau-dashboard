defmodule DAU.UserMessage.Conversation do
  @moduledoc """
  Enforce business logic related to a user's conversation with the tipline

  For every conversation, it expects the inbox, query and common tables to be linked
  already.
  """
  require Logger
  alias ElixirSense.Log
  alias DAU.UserMessage.Outbox
  alias DAU.UserMessage.Conversation.Hash
  alias DAU.UserMessage.Conversation.MessageAdded
  alias DAU.Feed
  alias DAU.UserMessage
  alias DAU.UserMessage.Conversation
  alias DAU.UserMessage.Conversation.Message
  alias DAU.Repo
  alias DAU.UserMessage.Inbox
  alias DAU.UserMessage.Query
  alias DAU.Feed.Common
  import Ecto.Query

  defstruct [
    :id,
    :sender_number,
    :feed_id,
    :response,
    :messages,
    :language,
    :count,
    :hash,
    :verification_status
  ]

  def new() do
    %Conversation{}
  end

  def set_id(%Conversation{} = query, id) do
    %{query | id: id}
  end

  def set_sender_number(%Conversation{} = query, sender_number) do
    %{query | sender_number: sender_number}
  end

  def set_messages(%Conversation{} = query, messages) do
    %{query | messages: messages}
  end

  def set_response(%Conversation{} = query, response) do
    %{query | response: response}
  end

  def set_feed_id(%Conversation{} = query, feed_id) do
    %{query | feed_id: feed_id}
  end

  def set_language(%Conversation{} = conversation, language) do
    %{conversation | language: language}
  end

  def set_count(%Conversation{} = query, count) do
    %{query | count: count}
  end

  def set_hash(%Conversation{} = query, hash) do
    %{query | hash: hash}
  end

  def set_verification_status(%Conversation{} = conversation, verification_status) do
    %{conversation | verification_status: verification_status}
  end

  @doc """
  Fetches full data related to a conversation.

  returns {:ok, conversation}  or {:error, "Conversation associated with inbox id not found"}
  """
  def get(inbox_id) when is_integer(inbox_id) do
    inbox =
      Repo.get(Inbox, inbox_id)
      |> Repo.preload(query: [:feed_common, :user_message_outbox, messages: [:hash]])

    case inbox do
      nil -> {:error, "Conversation associated with inbox id not found"}
      result -> {:ok, Map.get(result, :query)}
    end
  end

  # @type get_by_common_id(common_id: integer()) :: Conversation.t()
  def get_by_common_id(common_id) when is_integer(common_id) do
    Repo.get(Common, common_id)
    |> Repo.preload(query: [:feed_common, :user_message_outbox, messages: [:hash]])
    |> Map.get(:query)
    |> build()
  end

  def get_by_outbox_id(outbox_id) when is_integer(outbox_id) do
    Query
    |> join(:left, [q], o in Outbox, on: q.user_message_outbox == o.id)
    |> where([o, q], o.id == ^outbox_id)
    |> Repo.all()
    |> Repo.preload(:feed_common, :user_message_outbox, messages: [:hash])
    |> hd
    |> Conversation.build()
  end

  @doc """
  Build a Conversation.

  tech debt : a Query can have many inbox messages. In the current implementation, it just so happens
  that a query only has one message. That is why, we just take the first message and use it to assign
  the sender_number : `set_sender_number(query.messages |> hd |> Map.get(:sender_number))`
  """
  def build(inbox_id) when is_integer(inbox_id) do
    {:ok, %Query{} = query} = get(inbox_id)
    build(query)
  end

  def build(%Query{} = query) do
    conversation =
      Conversation.new()
      |> set_id(query.id)
      |> set_sender_number(query.messages |> hd |> Map.get(:sender_number))
      |> set_messages(Enum.map(query.messages, &Message.new(&1)))
      |> set_response(query.feed_common.user_response)
      |> set_feed_id(query.feed_common_id)
      |> set_language(query.messages |> hd |> Map.get(:user_language_input))
      |> set_hash(Hash.new(query.messages |> hd |> Map.get(:hash)))
      |> set_verification_status(query.feed_common.verification_status)

    {:ok, conversation}
  end

  def get_media_count(%Conversation{} = conversation) do
    Repo.get(Common, conversation.feed_id)
    |> Repo.preload(:hash_meta)
    |> Map.get(:hash_meta)
    |> Map.get(:count)
  end

  def get_first_message(%Conversation{} = conversation) do
    conversation.messages |> hd
  end

  @doc """
  Associate `HashMeta` with `Common`.

  This allows you to see how many instances of the media item in a Common
  have been sent to the dashboard.
  """
  def associate_hashmeta_with_feed(%Conversation{} = conversation, hashmeta_id) do
    Repo.get(Common, conversation.feed_id)
    |> Repo.preload(:hash_meta)
    |> Common.changeset(%{hash_meta_id: hashmeta_id})
    |> Repo.update()
  end

  @doc """
  The body parameters from a POST request to /gupshup/message are passed as `attrs`.
  Examples
  1. Message containing video from a user who chose English as their language for the tipline
  %{
    "media_type" => "video",
    "path" => "https://example.com/video-01.mp4",
    "sender_name" => "sender a",
    "sender_number" => "919999999990",
    "user_language_input" => "en"
  }
  1. Message containing audio from a user who chose Hindi as their language
  %{
    "media_type" => "audio",
    "path" => "https://example.com/audio-01.mp4",
    "sender_name" => "sender a",
    "sender_number" => "919999999990",
    "user_language_input" => "hi"
  }
  """
  def add_message(%{"media_type" => media_type} = attrs) when media_type in ["audio", "video"] do

    with {:ok, inbox} <- UserMessage.create_incoming_message(attrs),
         {file_key, file_hash} <- AWSS3.client().upload_to_s3(inbox.path),
         {:ok, inbox} <-
           UserMessage.update_user_message_file_metadata(inbox, %{
             file_key: file_key,
             file_hash: file_hash
           }),
         {:ok, common} <-
           Feed.add_to_common_feed(%{
             media_urls: [inbox.file_key],
             media_type: inbox.media_type,
             sender_number: inbox.sender_number,
             language: inbox.user_language_input
           }),
         {:ok, query} <-
           UserMessage.create_query_with_common(common, %{status: "pending"}),
         {:ok, inbox} <- UserMessage.associate_inbox_to_query(inbox.id, query) do
      {:ok,
       %MessageAdded{
         id: inbox.id,
         common_id: common.id,
         path: inbox.file_key,
         media_type: inbox.media_type
       }}
    else
      {:error, reason} ->
        Logger.error("Error adding message")
        Logger.error(reason)
        {:error, reason}
    end
  end

  def add_message(%{"media_type" => "text"} = attrs) do
    with {:ok, inbox} <- UserMessage.create_incoming_message(attrs),
         {:ok, inbox} <-
           UserMessage.update_user_message_text_file_hash(inbox, %{
             file_hash:
               :crypto.hash(:sha256, inbox.user_input_text)
               |> Base.encode16()
               |> String.downcase()
           }),
         {:ok, common} <-
           Feed.add_to_common_feed(
             %{
               media_urls: [inbox.user_input_text],
               media_type: inbox.media_type,
               sender_number: inbox.sender_number,
               language: inbox.user_language_input
             },
             block_spam_urls: true
           ),
         {:ok, query} <- UserMessage.create_query_with_common(common, %{status: "pending"}),
         {:ok, inbox} <- UserMessage.associate_inbox_to_query(inbox.id, query) do
      {:ok, %MessageAdded{id: inbox.id, path: inbox.file_key, media_type: inbox.media_type}}
    else
      {:error, reason} ->
        Logger.error("Error adding message")
        Logger.error(reason)
        {:error, reason}

      err ->
        Logger.error("Could not add message!!")

        Logger.error(err)
    end
  end

  def add_inbox(%{"media_type" => media_type} = attrs) when media_type in ["audio", "video"] do

     case UserMessage.create_incoming_message(attrs) do
      {:ok, inbox} ->
        {:ok, inbox}

      {:error, reason} ->
        Logger.error("Error while creating a new inbox")
        Logger.error(reason)
     end

  end

  def add_inbox(%{"media_type" => "text"} = attrs) do
    with {:ok, inbox} <- UserMessage.create_incoming_message(attrs),
         {:ok, inbox} <-
           UserMessage.update_user_message_text_file_hash(inbox, %{
             file_hash:
               :crypto.hash(:sha256, inbox.user_input_text)
               |> Base.encode16()
               |> String.downcase()
           }),
         {:ok, common} <-
           Feed.add_to_common_feed(
             %{
               media_urls: [inbox.user_input_text],
               media_type: inbox.media_type,
               sender_number: inbox.sender_number,
               language: inbox.user_language_input
             },
             block_spam_urls: true
           ),
         {:ok, query} <- UserMessage.create_query_with_common(common, %{status: "pending"}),
         {:ok, inbox} <- UserMessage.associate_inbox_to_query(inbox.id, query) do
      {:ok, inbox}
      # {:ok, %MessageAdded{id: inbox.id, path: inbox.file_key, media_type: inbox.media_type}}
    else
      {:error, reason} ->
        Logger.error("Error adding message")
        Logger.error(reason)
        {:error, reason}

      err ->
        Logger.error("Could not add message!!")

        Logger.error(err)
    end
  end

  def add_message_properties(%Inbox{} = inbox) do

    IO.inspect(inbox, label: "INBOX IS: ")

    with {file_key, file_hash} <- AWSS3.client().upload_to_s3(inbox.path),
         {:ok, inbox} <-
           UserMessage.update_user_message_file_metadata(inbox, %{
             file_key: file_key,
             file_hash: file_hash
           }),
         {:ok, common} <-
           Feed.add_to_common_feed(%{
             media_urls: [inbox.file_key],
             media_type: inbox.media_type,
             sender_number: inbox.sender_number,
             language: inbox.user_language_input
           }),
         {:ok, query} <-
           UserMessage.create_query_with_common(common, %{status: "pending"}),
         {:ok, inbox} <- UserMessage.associate_inbox_to_query(inbox.id, query) do
      {:ok,
       %MessageAdded{
         id: inbox.id,
         common_id: common.id,
         path: inbox.file_key,
         media_type: inbox.media_type
       }}
    else
      {:error, reason} ->
        Logger.error("Error adding message asynchronously ")
        Logger.error(reason)
        {:error, reason}
    end

  end



  def copy_response_fields(%Conversation{} = source, %Conversation{} = target) do
    # common = Repo.get(Common, )
  end
end
