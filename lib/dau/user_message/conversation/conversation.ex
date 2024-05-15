defmodule DAU.UserMessage.Conversation do
  @moduledoc """
  Enforce business logic related to a user's conversation with the tipline

  For every conversation, it expects the inbox, query and common tables to be linked
  already.
  """
  require Logger
  alias DAU.UserMessage.Conversation.MessageAdded
  alias DAU.Feed
  alias DAU.UserMessage
  alias DAU.UserMessage.Conversation
  alias DAU.UserMessage.Conversation.Message
  alias DAU.Repo
  alias DAU.UserMessage.Inbox
  alias DAU.UserMessage.Query
  alias DAU.Feed.Common

  defstruct [:id, :sender_number, :feed_id, :response, :messages]

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

  def set_feed_item(%Conversation{} = query, feed_item) do
    %{query | feed_item: feed_item}
  end

  def set_response(%Conversation{} = query, response) do
    %{query | response: response}
  end

  def set_feed_id(%Conversation{} = query, feed_id) do
    %{query | feed_id: feed_id}
  end

  @doc """
  Fetches full data related to a conversation.

  returns {:ok, conversation}  or {:error, "Conversation associated with inbox id not found"}
  """
  def get(inbox_id) when is_integer(inbox_id) do
    inbox =
      Repo.get(Inbox, inbox_id)
      |> Repo.preload(query: [:feed_common, :user_message_outbox, :messages])

    case inbox do
      nil -> {:error, "Conversation associated with inbox id not found"}
      result -> {:ok, Map.get(result, :query)}
    end
  end

  @doc """
  Build a Conversation.

  tech debt : a Query can have many inbox messages. In the current implementation, it just so happens
  that a query only has one message. That is why, we just take the first message and use it to assign
  the sender_number : `set_sender_number(query.messages |> hd |> Map.get(:sender_number))`
  """
  def build(%Query{} = query) do
    conversation =
      Conversation.new()
      |> set_id(query.id)
      |> set_sender_number(query.messages |> hd |> Map.get(:sender_number))
      |> set_messages(Enum.map(query.messages, &Message.new(&1)))
      |> set_response(query.feed_common.user_response)
      |> set_feed_id(query.feed_common_id)

    {:ok, conversation}
  end

  @doc """
  Associate `HashMeta` with `Common`.

  This allows you to see how many instances of the media item in a Common
  have been sent to the dashboard.
  """
  def save_feed_id(%Conversation{} = conversation) do
    Repo.get(Common, conversation.feed_id)
    |> Repo.preload(:hash_meta)
    |> Common.changeset(%{hash_meta_id: 5})
    |> Repo.update()
  end

  def command_a(inbox_id) do
    with {:ok, query} <- get(inbox_id),
         {:ok, conversation} <- build(query) do
      {:ok, conversation}
    else
      err -> err
    end
  end

  def add_count_to_item_in_feed(%Conversation{} = conversation, feed_id) do
    conversation
    |> set_feed_id(feed_id)
    |> save_feed_id
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
  def add_message(%{"media_type" => media_type} = attrs)
      when media_type in ["audio", "video"] do
    Logger.info(attrs)

    with {:ok, inbox} <- UserMessage.create_incoming_message(attrs),
         {file_key, file_hash} <- AWSS3.upload_to_s3(inbox.path),
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
         {:ok, query} <- UserMessage.create_query_with_common(common, %{status: "pending"}),
         {:ok, inbox} <- UserMessage.associate_inbox_to_query(inbox.id, query) do
      {:ok, %MessageAdded{id: inbox.id, path: inbox.file_key, media_type: inbox.media_type}}
    else
      {:error, reason} ->
        Logger.error(reason)
        {:error, reason}
    end
  end

  def add_message(%{"media_type" => "text"} = attrs) do
    IO.inspect("in text")
    Logger.info(attrs)
    # {:ok, inbox} = UserMessage.create_incoming_message(attrs)

    # {:ok, inbox} =
    #   UserMessage.update_user_message_file_metadata(inbox, %{
    #     file_key: "temp/video-01.mp4",
    #     file_hash: "abc"
    #   })

    # {:ok, common} =
    #   Feed.add_to_common_feed(%{
    #     media_urls: ["temp/video-01.mp4"],
    #     media_type: inbox.media_type,
    #     sender_number: inbox.sender_number,
    #     language: inbox.user_language_input
    #   })

    # {:ok, query} = UserMessage.create_query_with_common(common, %{status: "pending"})
    # {:ok, inbox} = UserMessage.associate_inbox_to_query(inbox.id, query)

    # build(query)
  end
end
