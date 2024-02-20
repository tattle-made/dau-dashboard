defmodule DAUWeb.QueryLiveTest do
  use DAUWeb.ConnCase

  import Phoenix.LiveViewTest
  import DAU.VerificationFixtures

  @create_attrs %{messages: ["option1", "option2"], status: "some status"}
  @update_attrs %{messages: ["option1"], status: "some updated status"}
  @invalid_attrs %{messages: [], status: nil}

  defp create_query(_) do
    query = query_fixture()
    %{query: query}
  end

  describe "Index" do
    setup [:create_query]

    test "lists all queries", %{conn: conn, query: query} do
      {:ok, _index_live, html} = live(conn, ~p"/queries")

      assert html =~ "Listing Queries"
      assert html =~ query.status
    end

    test "saves new query", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/queries")

      assert index_live |> element("a", "New Query") |> render_click() =~
               "New Query"

      assert_patch(index_live, ~p"/queries/new")

      assert index_live
             |> form("#query-form", query: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#query-form", query: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/queries")

      html = render(index_live)
      assert html =~ "Query created successfully"
      assert html =~ "some status"
    end

    test "updates query in listing", %{conn: conn, query: query} do
      {:ok, index_live, _html} = live(conn, ~p"/queries")

      assert index_live |> element("#queries-#{query.id} a", "Edit") |> render_click() =~
               "Edit Query"

      assert_patch(index_live, ~p"/queries/#{query}/edit")

      assert index_live
             |> form("#query-form", query: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#query-form", query: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/queries")

      html = render(index_live)
      assert html =~ "Query updated successfully"
      assert html =~ "some updated status"
    end

    test "deletes query in listing", %{conn: conn, query: query} do
      {:ok, index_live, _html} = live(conn, ~p"/queries")

      assert index_live |> element("#queries-#{query.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#queries-#{query.id}")
    end
  end

  describe "Show" do
    setup [:create_query]

    test "displays query", %{conn: conn, query: query} do
      {:ok, _show_live, html} = live(conn, ~p"/queries/#{query}")

      assert html =~ "Show Query"
      assert html =~ query.status
    end

    test "updates query within modal", %{conn: conn, query: query} do
      {:ok, show_live, _html} = live(conn, ~p"/queries/#{query}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Query"

      assert_patch(show_live, ~p"/queries/#{query}/show/edit")

      assert show_live
             |> form("#query-form", query: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#query-form", query: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/queries/#{query}")

      html = render(show_live)
      assert html =~ "Query updated successfully"
      assert html =~ "some updated status"
    end
  end
end
