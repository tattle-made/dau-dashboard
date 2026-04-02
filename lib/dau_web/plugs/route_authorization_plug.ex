defmodule DAUWeb.Plugs.RouteAuthorizationPlug do
  @moduledoc """
  Router-level authorization plug. Delegates decisions to
  Permission.RouteAuthorization.
  """

  import Plug.Conn
  import Phoenix.Controller

  alias Permission.RouteAuthorization

  @behaviour Plug

  @impl Plug
  def init(opts), do: opts

  @impl Plug
  def call(conn, opts) do
    permission = Keyword.fetch!(opts, :permission)
    user = conn.assigns[:current_user]

    if RouteAuthorization.allowed?(user, permission) do
      conn
    else
      conn
      |> put_status(:forbidden)
      |> text("Forbidden")
      |> halt()
    end
  end
end
