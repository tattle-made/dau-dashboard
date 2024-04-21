defmodule DAUWeb.Search.SearchLiveTest do
  alias DAU.FeedFixtures
  alias DAUWeb.SearchLive.Detail
  use DAUWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  setup :register_and_log_in_user

  describe "search filtering" do
    setup do
      common = FeedFixtures.valid_attributes()

      %{common: common}
    end

    test "filter by media type", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/demo/query")

      # assert html =~ "<h1>Showing all</h1>"

      # IO.inspect(view)

      view
      |> element("#video")
      |> render_click()

      # IO.inspect(rendered_result)

      # queries =
      #   rendered_result
      #   |> element("queries")

      # IO.inspect(queries)

      # assert_redirected(
      #   view,
      #   "/demo/query?media_type=video&verification_status=all&to=2024-04-10&from=2024-03-01&sort=newest&page_num=1"
      # )

      # |> follow_redirect(
      #   "/demo/query?media_type=video&verification_status=all&to=2024-04-10&from=2024-03-01&sort=newest&page_num=1"
      # )

      # IO.inspect(view)
      # IO.inspect(html)
    end

    @doc """

    """
    test "render search results" do
      # {:ok, _view, html} =
      #   live(
      #     conn,
      #     "/demo/query?media_type=video&taken_up_by=&verification_status=all&to=2024-04-17&from=2024-03-01&sort=newest&page_num=1"
      #   )

      # parsed_html = LiveViewTest.DOM.parse(html)
      # els = LiveViewTest.DOM.all(parsed_html, ".taken_up_by")

      # texts =
      #   Enum.map(els, &LiveViewTest.DOM.to_text/1)

      # IO.inspect(texts)
      # assert Enum.member?(texts, "denny")

      # IO.inspect(length(els))
      # IO.inspect(els |> hd)
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
      assert_raise FunctionClauseError, fn ->
        Detail.beautify_url(nil)
      end

      assert_raise FunctionClauseError, fn ->
        Detail.beautify_url(42)
      end
    end
  end
end
