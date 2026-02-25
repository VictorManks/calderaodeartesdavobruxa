defmodule Calderaodeartesdavobruxa.GalleryTest do
  use Calderaodeartesdavobruxa.DataCase

  alias Calderaodeartesdavobruxa.Gallery

  describe "artworks" do
    alias Calderaodeartesdavobruxa.Gallery.Artwork

    import Calderaodeartesdavobruxa.GalleryFixtures

    @invalid_attrs %{name: nil, description: nil, depth: nil, width: nil, category: nil, style: nil, subcategory: nil, materials: nil, height: nil, weight: nil, sent_price: nil, img: nil}

    test "list_artworks/0 returns all artworks" do
      artwork = artwork_fixture()
      assert Gallery.list_artworks() == [artwork]
    end

    test "get_artwork!/1 returns the artwork with given id" do
      artwork = artwork_fixture()
      assert Gallery.get_artwork!(artwork.id) == artwork
    end

    test "create_artwork/1 with valid data creates a artwork" do
      valid_attrs = %{name: "some name", description: "some description", depth: 120.5, width: 120.5, category: "some category", style: "some style", subcategory: "some subcategory", materials: "some materials", height: 120.5, weight: 120.5, sent_price: 42, img: "some img"}

      assert {:ok, %Artwork{} = artwork} = Gallery.create_artwork(valid_attrs)
      assert artwork.name == "some name"
      assert artwork.description == "some description"
      assert artwork.depth == 120.5
      assert artwork.width == 120.5
      assert artwork.category == "some category"
      assert artwork.style == "some style"
      assert artwork.subcategory == "some subcategory"
      assert artwork.materials == "some materials"
      assert artwork.height == 120.5
      assert artwork.weight == 120.5
      assert artwork.sent_price == 42
      assert artwork.img == "some img"
    end

    test "create_artwork/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Gallery.create_artwork(@invalid_attrs)
    end

    test "update_artwork/2 with valid data updates the artwork" do
      artwork = artwork_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description", depth: 456.7, width: 456.7, category: "some updated category", style: "some updated style", subcategory: "some updated subcategory", materials: "some updated materials", height: 456.7, weight: 456.7, sent_price: 43, img: "some updated img"}

      assert {:ok, %Artwork{} = artwork} = Gallery.update_artwork(artwork, update_attrs)
      assert artwork.name == "some updated name"
      assert artwork.description == "some updated description"
      assert artwork.depth == 456.7
      assert artwork.width == 456.7
      assert artwork.category == "some updated category"
      assert artwork.style == "some updated style"
      assert artwork.subcategory == "some updated subcategory"
      assert artwork.materials == "some updated materials"
      assert artwork.height == 456.7
      assert artwork.weight == 456.7
      assert artwork.sent_price == 43
      assert artwork.img == "some updated img"
    end

    test "update_artwork/2 with invalid data returns error changeset" do
      artwork = artwork_fixture()
      assert {:error, %Ecto.Changeset{}} = Gallery.update_artwork(artwork, @invalid_attrs)
      assert artwork == Gallery.get_artwork!(artwork.id)
    end

    test "delete_artwork/1 deletes the artwork" do
      artwork = artwork_fixture()
      assert {:ok, %Artwork{}} = Gallery.delete_artwork(artwork)
      assert_raise Ecto.NoResultsError, fn -> Gallery.get_artwork!(artwork.id) end
    end

    test "change_artwork/1 returns a artwork changeset" do
      artwork = artwork_fixture()
      assert %Ecto.Changeset{} = Gallery.change_artwork(artwork)
    end
  end
end
