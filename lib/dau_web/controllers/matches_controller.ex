defmodule DAUWeb.MatchesController do
  alias DAU.Feed.Common
  alias DAU.Repo
  alias DAU.UserMessage
  alias DAU.MediaMatch.Blake2B
  alias DAU.Feed
  use DAUWeb, :controller
  import Logger

  def index(conn, params) do
    IO.inspect(params)
    id = params["id"]
    matches = Blake2B.get_matches_by_common_id(id)
    render(conn, :index, matches: matches, src: id)
  end

  def import_response(conn, %{"src" => src, "target" => target}) do
    case Blake2B.copy_response_fields(src, target) do
      {:ok, common} ->
        common = Repo.get(Common, common.id) |> Repo.preload(:query)
        UserMessage.add_response_to_outbox(common)

        conn
        |> put_flash(:ok, "Successfully imported response")
        |> redirect(to: ~p"/demo/query/#{target}")

      {:error, reason} ->
        Logger.error("Unable to copy")
    end
  end
end
