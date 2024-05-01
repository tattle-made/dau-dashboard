defmodule DAUWeb.AnalyticsController do
  use DAUWeb, :controller

  def hello_world(conn, _paramas) do
    text(conn, "HELLO WORLD")
  end
end
