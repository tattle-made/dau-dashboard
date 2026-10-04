defmodule DAUWeb.Plugs.DisablePageCachingPlug do
  @moduledoc """
  Stops the browser from caching a rendered page.

  Without these headers the browser keeps the HTML on disk, so pressing back after
  logging out re-displays the last authenticated page. The session is already gone -
  the request simply never reaches the server - and only a refresh gets rejected.

  Declare it in controllers that render authenticated pages:

      plug DAUWeb.Plugs.DisablePageCachingPlug

  LiveView routes do not need it. Going back reconnects the socket, which runs the
  `{DAUWeb.UserAuth, :ensure_authenticated}` on_mount hook and redirects.
  """

  import Plug.Conn

  @behaviour Plug

  @impl Plug
  def init(opts), do: opts

  @impl Plug
  def call(conn, _opts) do
    conn
    |> put_resp_header("cache-control", "no-store, no-cache, must-revalidate, max-age=0")
    |> put_resp_header("pragma", "no-cache")
    |> put_resp_header("expires", "0")
  end
end
