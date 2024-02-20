defmodule DAUWeb.ResponseLiveTest do
  use DAUWeb.ConnCase

  import Phoenix.LiveViewTest
  import DAU.VerificationFixtures

  @create_attrs %{content: %{}}
  @update_attrs %{content: %{}}
  @invalid_attrs %{content: nil}

  defp create_response(_) do
    response = response_fixture()
    %{response: response}
  end

  describe "Index" do
    setup [:create_response]

    test "lists all response", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/response")

      assert html =~ "Listing Response"
    end

    test "saves new response", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/response")

      assert index_live |> element("a", "New Response") |> render_click() =~
               "New Response"

      assert_patch(index_live, ~p"/response/new")

      assert index_live
             |> form("#response-form", response: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#response-form", response: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/response")

      html = render(index_live)
      assert html =~ "Response created successfully"
    end

    test "updates response in listing", %{conn: conn, response: response} do
      {:ok, index_live, _html} = live(conn, ~p"/response")

      assert index_live |> element("#response-#{response.id} a", "Edit") |> render_click() =~
               "Edit Response"

      assert_patch(index_live, ~p"/response/#{response}/edit")

      assert index_live
             |> form("#response-form", response: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#response-form", response: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/response")

      html = render(index_live)
      assert html =~ "Response updated successfully"
    end

    test "deletes response in listing", %{conn: conn, response: response} do
      {:ok, index_live, _html} = live(conn, ~p"/response")

      assert index_live |> element("#response-#{response.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#response-#{response.id}")
    end
  end

  describe "Show" do
    setup [:create_response]

    test "displays response", %{conn: conn, response: response} do
      {:ok, _show_live, html} = live(conn, ~p"/response/#{response}")

      assert html =~ "Show Response"
    end

    test "updates response within modal", %{conn: conn, response: response} do
      {:ok, show_live, _html} = live(conn, ~p"/response/#{response}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Response"

      assert_patch(show_live, ~p"/response/#{response}/show/edit")

      assert show_live
             |> form("#response-form", response: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#response-form", response: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/response/#{response}")

      html = render(show_live)
      assert html =~ "Response updated successfully"
    end
  end
end
