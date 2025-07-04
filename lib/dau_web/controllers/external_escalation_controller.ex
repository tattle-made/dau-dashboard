defmodule DAUWeb.ExternalEscalationController do
  use DAUWeb, :controller
  alias DAU.ExternalEscalation
  require Logger

  def create(conn, params) do
    IO.inspect(params)
    # json(conn, %{message: "External escalation created"})

    case ExternalEscalation.process_external_escalation_entry(params) do
      {:ok, _entry} ->
        conn
        |> put_resp_content_type("application/json")
        |> resp(200, Jason.encode!(%{status: :ok}))
        |> send_resp()
      {:error, error} ->
        Logger.error("EXTERNAL ESCALATION CONTROLLER ERROR: #{inspect(error)}")
        conn
        |> put_resp_content_type("application/json")
        |> resp(500, Jason.encode!(%{status: :error, error: inspect(error)}))
        |> send_resp()
    end
  end
end
