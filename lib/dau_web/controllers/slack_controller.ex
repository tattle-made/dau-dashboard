defmodule DAUWeb.SlackController do
  use DAUWeb, :controller
  require Logger

  def create(conn, params) do
    IO.inspect(params)

    if Map.has_key?(params, "challenge") do
      conn |> send_resp(200, params["challenge"])
    end
    conn |> send_resp(200, "")
  end
end
