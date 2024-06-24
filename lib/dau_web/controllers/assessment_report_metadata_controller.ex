defmodule DAUWeb.AssessmentReportMetadataController do
  use DAUWeb, :controller
  # use DAUWeb, :html

  def show(conn, params) do
    form = %{email: "denny@gmail.com", username: "denny"}
    form = Phoenix.HTML.FormData.to_form(form, as: :my_form)

    # to_form(form) |> IO.inspect(label: "FORM")

    render(conn, :show, form: form, id: params["id"])
    # conn |> Plug.Conn.send_resp(200, [])
  end

  def create(conn, params) do
    id = params["id"]
    IO.inspect(params, label: "SUBMITTED VALUES")
    redirect(conn, to: "/demo/query/#{id}")
  end

  def edit(conn, _params) do
    conn |> Plug.Conn.send_resp(200, [])
  end
end
