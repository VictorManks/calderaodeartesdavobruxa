defmodule CalderaodeartedavobruxaWeb.ArtworkLive.Form do
  use CalderaodeartedavobruxaWeb, :live_view

  alias Calderaodeartedavobruxa.Gallery
  alias Calderaodeartedavobruxa.Gallery.Artwork

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage artwork records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="artwork-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="textarea" label="Description" />
        <.input field={@form[:style]} type="text" label="Style" />
        <.input field={@form[:category]} type="text" label="Category" />
        <.input field={@form[:subcategory]} type="text" label="Subcategory" />
        <.input field={@form[:materials]} type="textarea" label="Materials" />
        <.input field={@form[:width]} type="number" label="Width" step="any" />
        <.input field={@form[:depth]} type="number" label="Depth" step="any" />
        <.input field={@form[:height]} type="number" label="Height" step="any" />
        <.input field={@form[:weight]} type="number" label="Weight" step="any" />
        <.input field={@form[:sent_price]} type="number" label="Sent price" />
        <.input field={@form[:img]} type="text" label="Img" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Artwork</.button>
          <.button navigate={return_path(@return_to, @artwork)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    artwork = Gallery.get_artwork!(id)

    socket
    |> assign(:page_title, "Edit Artwork")
    |> assign(:artwork, artwork)
    |> assign(:form, to_form(Gallery.change_artwork(artwork)))
  end

  defp apply_action(socket, :new, _params) do
    artwork = %Artwork{}

    socket
    |> assign(:page_title, "New Artwork")
    |> assign(:artwork, artwork)
    |> assign(:form, to_form(Gallery.change_artwork(artwork)))
  end

  @impl true
  def handle_event("validate", %{"artwork" => artwork_params}, socket) do
    changeset = Gallery.change_artwork(socket.assigns.artwork, artwork_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"artwork" => artwork_params}, socket) do
    save_artwork(socket, socket.assigns.live_action, artwork_params)
  end

  defp save_artwork(socket, :edit, artwork_params) do
    case Gallery.update_artwork(socket.assigns.artwork, artwork_params) do
      {:ok, artwork} ->
        {:noreply,
         socket
         |> put_flash(:info, "Artwork updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, artwork))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_artwork(socket, :new, artwork_params) do
    case Gallery.create_artwork(artwork_params) do
      {:ok, artwork} ->
        {:noreply,
         socket
         |> put_flash(:info, "Artwork created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, artwork))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _artwork), do: ~p"/artworks"
  defp return_path("show", artwork), do: ~p"/artworks/#{artwork}"
end
