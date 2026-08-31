defmodule DAUWeb.AnalyticsController do
  use DAUWeb, :controller

  alias DAU.Analytics
  alias DAU.Accounts

  def hello_world(conn, _params) do
    data = Analytics.fetch_author_and_url()

    render(conn, :index, data: data)
  end

  def user_registrations(conn, params) do
    page =
      params
      |> Map.get("page", "1")
      |> String.to_integer()

    users = Accounts.list_recent_users(page)
    total_users = Accounts.count_users()

    render(conn, :user_registrations,
      users: users,
      page: page,
      total_users: total_users
    )
  end
end
