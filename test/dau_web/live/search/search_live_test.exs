defmodule DAUWeb.Search.SearchLiveTest do
  use DAUWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  setup :register_and_log_in_user

  describe "search filtering" do
    test "filter by media type", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/demo/query")

      # assert html =~ "<h1>Showing all</h1>"

      view
      |> element("#video")
      |> render_click()

      # |> follow_redirect(
      #   "/demo/query?media_type=video&verification_status=all&to=2024-04-10&from=2024-03-01&sort=newest&page_num=1"
      # )

      # IO.inspect(view)
      # IO.inspect(html)
    end
  end
end
