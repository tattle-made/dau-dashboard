defmodule DAUWeb.AnalyticsController do
  use DAUWeb, :controller

  alias DAU.Analytics
  alias DAU.Accounts
  alias DAU.Accounts.User
  alias Permission

  def hello_world(conn, _params) do
    data = Analytics.fetch_author_and_url()

    render(conn, :index, data: data)
  end

  def user_registrations(conn, params) do
    user = conn.assigns.current_user

    page =
      params
      |> Map.get("page", "1")
      |> String.to_integer()

    with :ok <- Permission.authorize(user, :view, User) do
      render(conn, :user_registrations,
        users: Accounts.list_recent_users(user, page),
        page: page,
        total_users: Accounts.count_users(user)
      )
    else
      {:error, :unauthorized} ->
        conn
        |> put_flash(:error, "You are not authorized to perform this action.")
        |> redirect(to: ~p"/")
    end
  end
end
