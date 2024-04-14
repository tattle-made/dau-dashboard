defmodule DAUWeb.Search.SearchLiveTest do
  alias DAUWeb.SearchLive.Detail
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

  describe "url preview" do
    test "url is longer than 40 characters" do
      url =
        "https://www.boomlive.in/fact-check/factcheck-car-overturning-incident-in-karnataka-viral-with-false-communal-claim-24887"

      new_url = Detail.beautify_url(url)
      assert new_url == "https://www.boomlive....communal-claim-24887"
    end

    test "url is shorter than 40 characters" do
      url =
        "https://www.boomlive.in/fact-check/"

      new_url = Detail.beautify_url(url)
      assert new_url == url
    end

    test "url is unsupported" do
      url = nil

      assert_raise FunctionClauseError, fn ->
        Detail.beautify_url(nil)
      end

      url = 42

      assert_raise FunctionClauseError, fn ->
        Detail.beautify_url(nil)
      end
    end
  end
end
