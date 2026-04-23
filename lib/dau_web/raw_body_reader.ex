defmodule DAUWeb.RawBodyReader do
  @moduledoc """
  Middleware to capture and store the raw request body in conn assigns.

  The raw body is stored in `conn.assigns[:raw_body]` for later use in controllers.

  This is used in Slack signature verification inside Slack Controller
  that requires access to the original raw body before any parsing.
  """
  def read_body(conn, opts) do
    case Plug.Conn.read_body(conn, opts) do
      {:ok, body, conn} ->
        conn = Plug.Conn.assign(conn, :raw_body, body)
        {:ok, body, conn}

      {:more, body, conn} ->
        conn = Plug.Conn.assign(conn, :raw_body, body)
        {:more, body, conn}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
