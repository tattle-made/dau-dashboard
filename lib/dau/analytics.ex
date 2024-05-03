defmodule DAU.Analytics do
  import Ecto.Query
  alias DAU.Feed.Common
  alias DAU.Repo

  def fetch_author_and_url do
    Common
    |> query_author_and_url()
    |> limit(10)
    |> offset(0)
    |> Repo.all()
  end

  defp query_author_and_url(query) do
    from c in query,
      select: %{
        username: fragment("jsonb_array_elements(?)->>'username'", c.factcheck_articles),
        url: fragment("jsonb_array_elements(?)->>'url'", c.factcheck_articles)
      }
  end
end
