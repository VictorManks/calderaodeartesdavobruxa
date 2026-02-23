defmodule CalderaodeartedavobruxaWeb.ArtworkLive.Index do
  use CalderaodeartedavobruxaWeb, :live_view

  alias Calderaodeartedavobruxa.Gallery

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Artworks
        <:actions>
          <.button variant="primary" navigate={~p"/artworks/new"}>
            <.icon name="hero-plus" /> New Artwork
          </.button>
        </:actions>
      </.header>

      <.table
        id="artworks"
        rows={@streams.artworks}
        row_click={fn {_id, artwork} -> JS.navigate(~p"/artworks/#{artwork}") end}
      >
        <:col :let={{_id, artwork}} label="Name">{artwork.name}</:col>
        <:col :let={{_id, artwork}} label="Description">{artwork.description}</:col>
        <:col :let={{_id, artwork}} label="Style">{artwork.style}</:col>
        <:col :let={{_id, artwork}} label="Category">{artwork.category}</:col>
        <:col :let={{_id, artwork}} label="Subcategory">{artwork.subcategory}</:col>
        <:col :let={{_id, artwork}} label="Materials">{artwork.materials}</:col>
        <:col :let={{_id, artwork}} label="Width">{artwork.width}</:col>
        <:col :let={{_id, artwork}} label="Depth">{artwork.depth}</:col>
        <:col :let={{_id, artwork}} label="Height">{artwork.height}</:col>
        <:col :let={{_id, artwork}} label="Weight">{artwork.weight}</:col>
        <:col :let={{_id, artwork}} label="Sent price">{artwork.sent_price}</:col>
        <:col :let={{_id, artwork}} label="Img">{artwork.img}</:col>
        <:action :let={{_id, artwork}}>
          <div class="sr-only">
            <.link navigate={~p"/artworks/#{artwork}"}>Show</.link>
          </div>
          <.link navigate={~p"/artworks/#{artwork}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, artwork}}>
          <.link
            phx-click={JS.push("delete", value: %{id: artwork.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Artworks")
     |> stream(:artworks, list_artworks())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    artwork = Gallery.get_artwork!(id)
    {:ok, _} = Gallery.delete_artwork(artwork)

    {:noreply, stream_delete(socket, :artworks, artwork)}
  end

  defp list_artworks() do
    Gallery.list_artworks()
  end
end
