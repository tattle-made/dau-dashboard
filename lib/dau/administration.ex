defmodule DAU.Administration do
  @moduledoc """
  Operations to assist dau admins with day to day functioning.

  This is an escape hatch for features that admins need on a day to day basis to
  support with the various dau secratariat workflows
  """
  alias DAU.UserMessage.Inbox
  alias DAU.Feed
  alias DAU.Feed.Common
  import Ecto.Query
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

  def get_file_key_by_hash(hash) do
  end
end
