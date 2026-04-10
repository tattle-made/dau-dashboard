defmodule DAUWeb.MatchesController do
  alias DAU.Feed.Common
  alias DAU.Repo
  alias DAU.UserMessage
  alias DAU.MediaMatch.Blake2B
  alias DAU.Feed
  alias Permission
  use DAUWeb, :controller
  import Logger

  def index(conn, params) do
    user = conn.assigns.current_user

    with :ok <- Permission.authorize(user, :edit, Common) do
      IO.inspect(params)
      id = params["id"]
      matches = Blake2B.get_matches_by_common_id(id)
      render(conn, :index, matches: matches, src: id)
    else
      {:error, :unauthorized} ->
        conn
        |> put_flash(:error, "You are not authorized to perform this action.")
        |> redirect(to: ~p"/")
    end
  end

  def import_response(conn, %{"src" => src, "target" => target}) do
    user = conn.assigns.current_user

    case Blake2B.copy_response_fields(src, target, user) do
      {:ok, common} ->
        common = Repo.get(Common, common.id) |> Repo.preload(:query)
        UserMessage.add_response_to_outbox(common, user)

        conn
        |> put_flash(:ok, "Successfully imported response")
        |> redirect(to: ~p"/demo/query/#{target}")

      {:error, :unauthorized} ->
        conn
        |> put_flash(:error, "You are not authorized to perform this action.")
        |> redirect(to: ~p"/demo/query/#{target}")

      {:error, reason} ->
        Logger.error("Unable to copy")
    end
  end
end
