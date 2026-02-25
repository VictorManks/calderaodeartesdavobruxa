defmodule CalderaodeartesdavobruxaWeb.ArtworkLiveTest do
  use CalderaodeartesdavobruxaWeb.ConnCase

  import Phoenix.LiveViewTest
  import Calderaodeartesdavobruxa.GalleryFixtures

  @create_attrs %{name: "some name", description: "some description", depth: 120.5, width: 120.5, category: "some category", style: "some style", subcategory: "some subcategory", materials: "some materials", height: 120.5, weight: 120.5, sent_price: 42, img: "some img"}
  @update_attrs %{name: "some updated name", description: "some updated description", depth: 456.7, width: 456.7, category: "some updated category", style: "some updated style", subcategory: "some updated subcategory", materials: "some updated materials", height: 456.7, weight: 456.7, sent_price: 43, img: "some updated img"}
  @invalid_attrs %{name: nil, description: nil, depth: nil, width: nil, category: nil, style: nil, subcategory: nil, materials: nil, height: nil, weight: nil, sent_price: nil, img: nil}
  defp create_artwork(_) do
    artwork = artwork_fixture()

    %{artwork: artwork}
  end

  describe "Index" do
    setup [:register_and_log_in_user, :create_artwork]

    test "lists all artworks", %{conn: conn, artwork: artwork} do
      {:ok, _index_live, html} = live(conn, ~p"/artworks")

      assert html =~ "Listing Artworks"
      assert html =~ artwork.name
    end

    test "deletes artwork in listing", %{conn: conn, artwork: artwork} do
      {:ok, index_live, _html} = live(conn, ~p"/artworks")

      assert index_live |> element("#artworks-#{artwork.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#artworks-#{artwork.id}")
    end
  end

  describe "Index as admin" do
    setup [:register_and_log_in_admin, :create_artwork]

    test "saves new artwork", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/artworks")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Artwork")
               |> render_click()
               |> follow_redirect(conn, ~p"/artworks/new")

      assert render(form_live) =~ "New Artwork"

      assert form_live
             |> form("#artwork-form", artwork: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#artwork-form", artwork: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/artworks")

      html = render(index_live)
      assert html =~ "Artwork created successfully"
      assert html =~ "some name"
    end

    test "updates artwork in listing", %{conn: conn, artwork: artwork} do
      {:ok, index_live, _html} = live(conn, ~p"/artworks")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#artworks-#{artwork.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/artworks/#{artwork}/edit")

      assert render(form_live) =~ "Edit Artwork"

      assert form_live
             |> form("#artwork-form", artwork: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#artwork-form", artwork: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/artworks")

      html = render(index_live)
      assert html =~ "Artwork updated successfully"
      assert html =~ "some updated name"
    end
  end

  describe "Show" do
    setup [:register_and_log_in_user, :create_artwork]

    test "displays artwork", %{conn: conn, artwork: artwork} do
      {:ok, _show_live, html} = live(conn, ~p"/artworks/#{artwork}")

      assert html =~ "Show Artwork"
      assert html =~ artwork.name
    end
  end

  describe "Show as admin" do
    setup [:register_and_log_in_admin, :create_artwork]

    test "updates artwork and returns to show", %{conn: conn, artwork: artwork} do
      {:ok, show_live, _html} = live(conn, ~p"/artworks/#{artwork}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/artworks/#{artwork}/edit?return_to=show")

      assert render(form_live) =~ "Edit Artwork"

      assert form_live
             |> form("#artwork-form", artwork: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#artwork-form", artwork: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/artworks/#{artwork}")

      html = render(show_live)
      assert html =~ "Artwork updated successfully"
      assert html =~ "some updated name"
    end
  end
end
