defmodule Calderaodeartesdavobruxa.GalleryFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Calderaodeartesdavobruxa.Gallery` context.
  """

  @doc """
  Generate a artwork.
  """
  def artwork_fixture(attrs \\ %{}) do
    {:ok, artwork} =
      attrs
      |> Enum.into(%{
        category: "some category",
        depth: 120.5,
        description: "some description",
        height: 120.5,
        img: "some img",
        materials: "some materials",
        name: "some name",
        sent_price: 42,
        style: "some style",
        subcategory: "some subcategory",
        weight: 120.5,
        width: 120.5
      })
      |> Calderaodeartesdavobruxa.Gallery.create_artwork()

    artwork
  end
end
