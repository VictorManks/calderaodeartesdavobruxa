defmodule CalderaodeartesdavobruxaWeb.ArtworkLive.Index do
  use CalderaodeartesdavobruxaWeb, :live_view

  alias Calderaodeartesdavobruxa.Gallery

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Obras
        <:actions>
          <.button :if={@is_admin} variant="primary" navigate={~p"/artworks/new"}>
            <.icon name="hero-plus" /> Nova Obra
          </.button>
        </:actions>
      </.header>

      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-8 mt-6">
        <div
          :for={{id, artwork} <- @streams.artworks}
          id={id}
          class="artwork-card card bg-base-100 shadow-md hover:shadow-2xl transition-shadow duration-300 ease-in-out relative hover:z-10"
        >
          <.link navigate={~p"/artworks/#{artwork}"} class="block group">
            <figure class="relative">
              <img
                :if={artwork.img && artwork.img != ""}
                src={artwork.img}
                alt={artwork.name}
                class="artwork-img w-full h-72 object-cover rounded-t-2xl transition-all duration-500"
              />
              <div
                :if={!artwork.img || artwork.img == ""}
                class="w-full h-72 bg-base-200 flex items-center justify-center rounded-t-2xl"
              >
                <.icon name="hero-photo" class="w-20 h-20 text-base-content/30" />
              </div>
              <span
                :if={artwork.sold}
                class="badge badge-error absolute top-3 right-3 text-sm px-3 py-1"
              >
                Vendida
              </span>
            </figure>

            <div class="card-body p-5 gap-3">
              <h2 class="card-title text-lg font-semibold line-clamp-1">{artwork.name}</h2>

              <div class="flex flex-wrap gap-1.5">
                <span :if={artwork.style && artwork.style != ""} class="badge badge-soft badge-primary text-xs">
                  {artwork.style}
                </span>
                <span :if={artwork.category && artwork.category != ""} class="badge badge-soft badge-secondary text-xs">
                  {artwork.category}
                </span>
              </div>

              <p
                :if={artwork.description && artwork.description != ""}
                class="text-sm text-base-content/70 line-clamp-3 leading-relaxed"
              >
                {artwork.description}
              </p>
            </div>
          </.link>

          <div :if={@is_admin} class="px-5 pb-5 flex justify-end gap-1">
            <.link navigate={~p"/artworks/#{artwork}/edit"} class="btn btn-ghost btn-sm">
              <.icon name="hero-pencil-square" class="w-4 h-4" />
            </.link>
            <.link
              phx-click={JS.push("delete", value: %{id: artwork.id}) |> hide("##{id}")}
              data-confirm="Tem certeza?"
              class="btn btn-ghost btn-sm text-error"
            >
              <.icon name="hero-trash" class="w-4 h-4" />
            </.link>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    is_admin =
      socket.assigns[:current_scope] &&
        socket.assigns.current_scope.user &&
        socket.assigns.current_scope.user.role == :admin

    {:ok,
     socket
     |> assign(:page_title, "Obras")
     |> assign(:is_admin, is_admin)
     |> stream(:artworks, Gallery.list_artworks())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    artwork = Gallery.get_artwork!(id)
    {:ok, _} = Gallery.delete_artwork(artwork)

    {:noreply, stream_delete(socket, :artworks, artwork)}
  end
end
