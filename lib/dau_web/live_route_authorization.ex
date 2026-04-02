defmodule DAUWeb.LiveRouteAuthorization do
  @moduledoc """
  LiveView authorization hooks that mirror router-level authorization.
  """

  use DAUWeb, :verified_routes

  import Phoenix.LiveView

  alias Permission.RouteAuthorization

  def on_mount(:allow_users, _params, _session, socket) do
    authorize(socket, :allow_users)
  end

  def on_mount(:deny_users, _params, _session, socket) do
    authorize(socket, :deny_users)
  end

  defp authorize(socket, permission) do
    user = socket.assigns[:current_user]

    if RouteAuthorization.allowed?(user, permission) do
      {:cont, socket}
    else
      socket =
        socket
        |> put_flash(:error, "You are not authorized to access this page.")
        |> redirect(to: ~p"/")

      {:halt, socket}
    end
  end
end
