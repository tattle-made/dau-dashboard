defmodule DAU.Analytics do
  import Ecto.Query
  alias DAU.Feed.Common
  alias DAU.Repo

  def fetch_data do
    query =
      from(c in Common,
        select: fragment("jsonb_array_elements_text(?->'factcheck_articles'->'url')", c)
      )

    Repo.all(query)
  end
end
