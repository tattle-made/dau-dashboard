defmodule DAU.Backfiling.V040 do
  alias DAU.UserMessage.Conversation.MessageAdded
  alias DAU.MediaMatch.Blake2B
  alias DAU.UserMessage.Query
  alias DAU.UserMessage.Inbox
  alias DAU.Repo
  alias DAU.Feed.Common
  import Ecto.Query

  def run() do
    items =
      1..total_common()
      |> Enum.map(&get_common_by_id(&1))
      |> Enum.filter(fn common -> common != nil end)
      |> Enum.map(&attach_matching_inbox(&1))
      |> Enum.map(&do_inbox_operations(&1))
      |> IO.inspect()

    length(items)
  end

  def index_media() do
    items =
      1..total_common()
      |> Enum.map(&get_common_by_id(&1))
      |> Enum.filter(fn common -> common != nil end)
      |> Enum.map(fn item ->
        %MessageAdded{id: item["id"], path: item["media_url"], media_type: item["media_type"]}
      end)
      |> Enum.map(&Blake2B.create_job(&1))
      |> IO.inspect()

    # |> Enum.map(&Blake2B.create_job)

    # MediaMatch.Blake2B.create_job(message_added)

    length(items)
  end

  @doc """
  nil when common with that id does no exist
  nil when the media_url does not start with app-data

  """
  def get_common_by_id(id) do
    Common
    |> select([c], %{"id" => c.id, "media_urls" => c.media_urls, "media_type" => c.media_type})
    |> where([c], c.id == ^id)
    |> Repo.all()
    |> case do
      [item] ->
        url = item |> Map.get("media_urls") |> hd
        # media_type = Map.get(item, "media_type")

        item =
          case String.starts_with?(url, "app-data/") do
            true ->
              item =
                item |> Map.put("media_url", url) |> Map.delete("media_urls")

            false ->
              nil
          end

        item

      [] ->
        nil
    end
  end

  @doc """
  sample input
  %{
    "media_url" => "app-data/3b3d9b9a-20f9-493f-b4b1-099c5601f43e",
    "id" => 602,
    "media_type" => :video
  } or
  %{
    "media_url" => "app-data/85a0d305-8373-4712-a514-45b3923bd2a1",
    "id" => 527,
    "media_type" => :audio
  }
  """
  def attach_matching_inbox(attrs) do
    inbox_response = Repo.get_by(Inbox, %{file_key: attrs["media_url"]})
    inbox = %{id: inbox_response.id}

    %{common: attrs, inbox: inbox}
  end

  def total_common() do
    Common
    |> select([c], count(c))
    |> Repo.all()
    |> hd
  end

  def do_inbox_operations(attrs) do
    common_id = attrs.common["id"]
    inbox_id = attrs.inbox.id

    result =
      case %Query{feed_common_id: common_id} |> Repo.insert() do
        {:ok, query} ->
          inbox = Repo.get(Inbox, inbox_id) |> Repo.preload(:query)
          query = Repo.get(Query, query.id)

          case Inbox.associate_query_changeset(inbox, query) |> Repo.update() do
            {:ok, inbox} -> :ok
            error -> :error
          end

        err ->
          IO.puts("error in inbox operations #{common_id}")
          IO.inspect(err)
          :error
      end

    Map.put(attrs, :result, result)
  end
end
