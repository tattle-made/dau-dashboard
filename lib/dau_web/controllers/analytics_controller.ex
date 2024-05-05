defmodule DAUWeb.AnalyticsController do
  use DAUWeb, :controller
  alias DAU.Analytics

  def hello_world(conn, _params) do
    data = Analytics.fetch_author_and_url()
    render(conn, :index, data: data)
  end
end
