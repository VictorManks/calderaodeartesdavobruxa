defmodule CalderaodeartesdavobruxaWeb.ArtworkLive.Show do
  use CalderaodeartesdavobruxaWeb, :live_view

  alias Calderaodeartesdavobruxa.Gallery

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Artwork {@artwork.id}
        <:subtitle>This is a artwork record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/artworks"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/artworks/#{@artwork}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit artwork
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Name">{@artwork.name}</:item>
        <:item title="Description">{@artwork.description}</:item>
        <:item title="Style">{@artwork.style}</:item>
        <:item title="Category">{@artwork.category}</:item>
        <:item title="Subcategory">{@artwork.subcategory}</:item>
        <:item title="Materials">{@artwork.materials}</:item>
        <:item title="Width">{@artwork.width}</:item>
        <:item title="Depth">{@artwork.depth}</:item>
        <:item title="Height">{@artwork.height}</:item>
        <:item title="Weight">{@artwork.weight}</:item>
        <:item title="Sent price">{@artwork.sent_price}</:item>
        <:item title="Img">{@artwork.img}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Artwork")
     |> assign(:artwork, Gallery.get_artwork!(id))}
  end
end
