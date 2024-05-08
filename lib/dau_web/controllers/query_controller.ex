defmodule DAUWeb.QueryController do
  alias DAU.Feed
  use DAUWeb, :controller

  def index(conn, params) do
    IO.inspect(params)
    id = params["id"]
    data = Feed.get_queries(id) |> Map.get(:queries) |> IO.inspect()
    render(conn, :index, data: data)
  end
end
