defmodule CalderaodeartesdavobruxaWeb.ArtworkLive.Form do
  use CalderaodeartesdavobruxaWeb, :live_view

  alias Calderaodeartesdavobruxa.Gallery
  alias Calderaodeartesdavobruxa.Gallery.Artwork

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Preencha os dados da obra.</:subtitle>
      </.header>

      <.form for={@form} id="artwork-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:name]} type="text" label="Nome" />
        <.input field={@form[:description]} type="textarea" label="Descrição" />
        <.input field={@form[:style]} type="text" label="Estilo" />
        <.input field={@form[:category]} type="text" label="Categoria" />
        <.input field={@form[:subcategory]} type="text" label="Subcategoria" />
        <.input field={@form[:materials]} type="textarea" label="Materiais" />
        <.input field={@form[:width]} type="number" label="Largura (cm)" step="any" />
        <.input field={@form[:depth]} type="number" label="Profundidade (cm)" step="any" />
        <.input field={@form[:height]} type="number" label="Altura (cm)" step="any" />
        <.input field={@form[:weight]} type="number" label="Peso (kg)" step="any" />
        <.input field={@form[:sent_price]} type="number" label="Preço" />
        <.input field={@form[:img]} type="text" label="Link da imagem" />
        <.input field={@form[:sold]} type="checkbox" label="Vendida" />
        <footer>
          <.button phx-disable-with="Salvando..." variant="primary">Salvar Obra</.button>
          <.button navigate={return_path(@return_to, @artwork)}>Cancelar</.button>
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
    |> assign(:page_title, "Editar Obra")
    |> assign(:artwork, artwork)
    |> assign(:form, to_form(Gallery.change_artwork(artwork)))
  end

  defp apply_action(socket, :new, _params) do
    artwork = %Artwork{}

    socket
    |> assign(:page_title, "Nova Obra")
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
         |> put_flash(:info, "Obra atualizada com sucesso")
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
         |> put_flash(:info, "Obra criada com sucesso")
         |> push_navigate(to: return_path(socket.assigns.return_to, artwork))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _artwork), do: ~p"/artworks"
  defp return_path("show", artwork), do: ~p"/artworks/#{artwork}"
end
