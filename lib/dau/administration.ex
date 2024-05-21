defmodule DAU.Administration do
  @moduledoc """
  Operations to assist dau admins with day to day functioning.

  This is an escape hatch for features that admins need on a day to day basis to
  support with the various dau secratariat workflows
  """
  alias DAU.MediaMatch.Hash
  alias DAU.UserMessage.Query
  alias DAU.UserMessage.Conversation
  alias DAU.UserMessage.Outbox
  alias DAU.UserMessage.Inbox
  alias DAU.Feed
  alias DAU.Feed.Common
  alias DAU.Repo

  def get_total_queries() do
    Common |> select([c], count(c.id)) |> Repo.all()
  end

  def get_queries_with_assessment_report(page_num) do
    Common
    |> where([c], not is_nil(c.user_response))
    |> limit(5)
    |> offset(5 * (^page_num - 1))
    |> Repo.all()
  end

  def get_user_number(query_id) do
    query = Feed.get_feed_item_by_id(query_id)
    query.sender_number
  end

  def analyze_user_language(sender_number) do
    Inbox |> where([c], c.sender_number == ^sender_number) |> Repo.all()
  end

  def add_user_language_to_query(query_id, language) do
    query = Feed.get_feed_item_by_id(query_id)
    query |> Common.changeset(%{language: language}) |> Repo.update()
  end

  def group_by_file_hash(page_num) do
    Inbox
    |> group_by([c], c.file_hash)
    |> select([c], {c.file_hash, count(c.id)})
    |> limit(20)
    |> offset(20 * (^page_num - 1))
    |> Repo.all()
  end

  def get_file_key_by_hash(command \\ nil) do
    command =
      case command do
        nil -> IO.gets("enter command (next, quit)\n")
        _ -> command
      end

    case command do
      ~c"next\n" -> get_file_key_by_hash(~c"next\n")
      ~c"quit\n" -> "process exited"
      ~c"\n" -> IO.puts("chose default next")
      _ -> IO.puts("catchall")
    end
  end

  def send_auto_generated_response_to_user(_query_id) do
    # query = Repo.get(Common, qery_id)
    # sender_number = query.sender_number
    # language = query.language

    # response = get_response_type()
    # IO.puts("response")

    # response =
  end

  def get_conversation_by_id(id) do
    Conversation.get_by_common_id(id)
    |> Conversation.build()
  end

  def delete_query_by_id(id) do
    query = Repo.get_by(Query, %{feed_common_id: id})
    %{id: query_id, user_message_outbox_id: outbox_id} = query
    IO.puts("query_id : #{query_id}")
    IO.puts("outbox_id : #{outbox_id}")
    # get inbox and hash
    inbox = Repo.get_by(Inbox, %{query_id: query_id}) |> Repo.preload(:hash)
    %{id: inbox_id, hash: hash} = inbox
    IO.puts("inbox_id : #{inbox_id}")
    IO.puts("hash : #{inspect(hash)}")

    hash_id =
      case hash do
        nil ->
          nil

        anything ->
          %{id: hash_id} = anything
          hash_id
      end

    IO.puts("hash_id : #{hash_id}")

    if hash_id != nil, do: Repo.get(Hash, hash_id) |> Repo.delete()
    Repo.get(Inbox, inbox_id) |> Repo.delete()
    Repo.get(Query, query_id) |> Repo.delete()
    if outbox_id != nil, do: Repo.get(Outbox, outbox_id) |> Repo.delete()

    Repo.get(Common, id) |> Repo.preload(:query) |> Repo.delete()
  end
end
