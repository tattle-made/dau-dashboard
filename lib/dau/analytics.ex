defmodule DAU.Analytics do
  import Ecto.Query
  alias DAU.Feed.Common
  alias DAU.Repo

  def fetch_author_and_url(opts \\ []) do
    query =
      Common
      |> query_author_and_url()

    query =
      case Keyword.get(opts, :test_run) do
        true -> query |> limit(20) |> offset(0)
        _ -> query
      end

    query
    |> Repo.all()
    |> count_urls_per_username()
  end

  defp query_author_and_url(query) do
    from c in query,
      select: %{
        username: fragment("jsonb_array_elements(?)->>'username'", c.factcheck_articles),
        url: fragment("jsonb_array_elements(?)->>'url'", c.factcheck_articles)
      }
  end

  defp count_urls_per_username(data) do
    data
    |> Enum.group_by(& &1.username)
    |> Enum.map(fn {username, urls} -> %{username: username, url_count: Enum.count(urls)} end)
    |> Enum.sort(&(&1.url_count >= &2.url_count))
  end
end
