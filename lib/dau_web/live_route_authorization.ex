defmodule DAUWeb.LiveRouteAuthorization do
  @moduledoc """
  LiveView authorization hooks that mirror router-level authorization.
  """

  use DAUWeb, :verified_routes

  import Phoenix.LiveView

  alias Permission.RouteAuthorization

  def on_mount(:allow_driveby_user, _params, _session, socket) do
    authorize(socket, :allow_driveby_user)
  end

  def on_mount(:deny_driveby_user, _params, _session, socket) do
    authorize(socket, :deny_driveby_user)
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
