defmodule DAUWeb.ManipulatedMediaLiveTest do
  use DAUWeb.ConnCase

  import Phoenix.LiveViewTest
  import DAU.CanonFixtures

  @create_attrs %{description: "some description", url: "some url"}
  @update_attrs %{description: "some updated description", url: "some updated url"}
  @invalid_attrs %{description: nil, url: nil}

  defp create_manipulated_media(_) do
    manipulated_media = manipulated_media_fixture()
    %{manipulated_media: manipulated_media}
  end

  describe "Index" do
    setup [:create_manipulated_media]

    test "lists all manipulated_media", %{conn: conn, manipulated_media: manipulated_media} do
      {:ok, _index_live, html} = live(conn, ~p"/manipulated_media")

      assert html =~ "Listing Manipulated media"
      assert html =~ manipulated_media.description
    end

    test "saves new manipulated_media", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/manipulated_media")

      assert index_live |> element("a", "New Manipulated media") |> render_click() =~
               "New Manipulated media"

      assert_patch(index_live, ~p"/manipulated_media/new")

      assert index_live
             |> form("#manipulated_media-form", manipulated_media: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#manipulated_media-form", manipulated_media: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/manipulated_media")

      html = render(index_live)
      assert html =~ "Manipulated media created successfully"
      assert html =~ "some description"
    end

    test "updates manipulated_media in listing", %{conn: conn, manipulated_media: manipulated_media} do
      {:ok, index_live, _html} = live(conn, ~p"/manipulated_media")

      assert index_live |> element("#manipulated_media-#{manipulated_media.id} a", "Edit") |> render_click() =~
               "Edit Manipulated media"

      assert_patch(index_live, ~p"/manipulated_media/#{manipulated_media}/edit")

      assert index_live
             |> form("#manipulated_media-form", manipulated_media: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#manipulated_media-form", manipulated_media: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/manipulated_media")

      html = render(index_live)
      assert html =~ "Manipulated media updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes manipulated_media in listing", %{conn: conn, manipulated_media: manipulated_media} do
      {:ok, index_live, _html} = live(conn, ~p"/manipulated_media")

      assert index_live |> element("#manipulated_media-#{manipulated_media.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#manipulated_media-#{manipulated_media.id}")
    end
  end

  describe "Show" do
    setup [:create_manipulated_media]

    test "displays manipulated_media", %{conn: conn, manipulated_media: manipulated_media} do
      {:ok, _show_live, html} = live(conn, ~p"/manipulated_media/#{manipulated_media}")

      assert html =~ "Show Manipulated media"
      assert html =~ manipulated_media.description
    end

    test "updates manipulated_media within modal", %{conn: conn, manipulated_media: manipulated_media} do
      {:ok, show_live, _html} = live(conn, ~p"/manipulated_media/#{manipulated_media}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Manipulated media"

      assert_patch(show_live, ~p"/manipulated_media/#{manipulated_media}/show/edit")

      assert show_live
             |> form("#manipulated_media-form", manipulated_media: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#manipulated_media-form", manipulated_media: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/manipulated_media/#{manipulated_media}")

      html = render(show_live)
      assert html =~ "Manipulated media updated successfully"
      assert html =~ "some updated description"
    end
  end
end
