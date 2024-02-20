defmodule DAUWeb.FactcheckArticleLiveTest do
  use DAUWeb.ConnCase

  import Phoenix.LiveViewTest
  import DAU.CanonFixtures

  @create_attrs %{title: "some title", author: "some author", url: "some url", publisher: "some publisher", excerpt: "some excerpt"}
  @update_attrs %{title: "some updated title", author: "some updated author", url: "some updated url", publisher: "some updated publisher", excerpt: "some updated excerpt"}
  @invalid_attrs %{title: nil, author: nil, url: nil, publisher: nil, excerpt: nil}

  defp create_factcheck_article(_) do
    factcheck_article = factcheck_article_fixture()
    %{factcheck_article: factcheck_article}
  end

  describe "Index" do
    setup [:create_factcheck_article]

    test "lists all factcheck_articles", %{conn: conn, factcheck_article: factcheck_article} do
      {:ok, _index_live, html} = live(conn, ~p"/factcheck_articles")

      assert html =~ "Listing Factcheck articles"
      assert html =~ factcheck_article.title
    end

    test "saves new factcheck_article", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/factcheck_articles")

      assert index_live |> element("a", "New Factcheck article") |> render_click() =~
               "New Factcheck article"

      assert_patch(index_live, ~p"/factcheck_articles/new")

      assert index_live
             |> form("#factcheck_article-form", factcheck_article: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#factcheck_article-form", factcheck_article: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/factcheck_articles")

      html = render(index_live)
      assert html =~ "Factcheck article created successfully"
      assert html =~ "some title"
    end

    test "updates factcheck_article in listing", %{conn: conn, factcheck_article: factcheck_article} do
      {:ok, index_live, _html} = live(conn, ~p"/factcheck_articles")

      assert index_live |> element("#factcheck_articles-#{factcheck_article.id} a", "Edit") |> render_click() =~
               "Edit Factcheck article"

      assert_patch(index_live, ~p"/factcheck_articles/#{factcheck_article}/edit")

      assert index_live
             |> form("#factcheck_article-form", factcheck_article: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#factcheck_article-form", factcheck_article: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/factcheck_articles")

      html = render(index_live)
      assert html =~ "Factcheck article updated successfully"
      assert html =~ "some updated title"
    end

    test "deletes factcheck_article in listing", %{conn: conn, factcheck_article: factcheck_article} do
      {:ok, index_live, _html} = live(conn, ~p"/factcheck_articles")

      assert index_live |> element("#factcheck_articles-#{factcheck_article.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#factcheck_articles-#{factcheck_article.id}")
    end
  end

  describe "Show" do
    setup [:create_factcheck_article]

    test "displays factcheck_article", %{conn: conn, factcheck_article: factcheck_article} do
      {:ok, _show_live, html} = live(conn, ~p"/factcheck_articles/#{factcheck_article}")

      assert html =~ "Show Factcheck article"
      assert html =~ factcheck_article.title
    end

    test "updates factcheck_article within modal", %{conn: conn, factcheck_article: factcheck_article} do
      {:ok, show_live, _html} = live(conn, ~p"/factcheck_articles/#{factcheck_article}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Factcheck article"

      assert_patch(show_live, ~p"/factcheck_articles/#{factcheck_article}/show/edit")

      assert show_live
             |> form("#factcheck_article-form", factcheck_article: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#factcheck_article-form", factcheck_article: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/factcheck_articles/#{factcheck_article}")

      html = render(show_live)
      assert html =~ "Factcheck article updated successfully"
      assert html =~ "some updated title"
    end
  end
end
