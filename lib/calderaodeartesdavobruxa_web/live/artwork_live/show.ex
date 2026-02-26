defmodule CalderaodeartesdavobruxaWeb.ArtworkLive.Show do
  use CalderaodeartesdavobruxaWeb, :live_view

  alias Calderaodeartesdavobruxa.Gallery
  alias Calderaodeartesdavobruxa.Accounts
  alias Calderaodeartesdavobruxa.Accounts.Opinion
  import CalderaodeartesdavobruxaWeb.OpinionComponents

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <%!-- Navegação de volta --%>
      <div class="mb-4 flex items-center justify-between">
        <.link navigate={~p"/artworks"} class="btn btn-ghost btn-sm gap-1">
          <.icon name="hero-arrow-left" class="w-4 h-4" /> Voltar às obras
        </.link>
        <.link
          :if={@is_admin}
          navigate={~p"/artworks/#{@artwork}/edit?return_to=show"}
          class="btn btn-primary btn-sm gap-1"
        >
          <.icon name="hero-pencil-square" class="w-4 h-4" /> Editar
        </.link>
      </div>

      <%!-- Card principal da obra --%>
      <div class="card bg-base-100 shadow-lg overflow-hidden">
        <div class="lg:flex">
          <%!-- Imagem --%>
          <div class="lg:w-1/2 relative">
            <img
              :if={@artwork.img && @artwork.img != ""}
              src={@artwork.img}
              alt={@artwork.name}
              class="w-full h-80 lg:h-full object-cover"
            />
            <div
              :if={!@artwork.img || @artwork.img == ""}
              class="w-full h-80 lg:h-full bg-base-200 flex items-center justify-center"
            >
              <.icon name="hero-photo" class="w-20 h-20 text-base-content/30" />
            </div>
            <span :if={@artwork.sold} class="badge badge-error absolute top-3 left-3 text-sm px-3 py-2">
              Vendida
            </span>
          </div>

          <%!-- Informações --%>
          <div class="lg:w-1/2 p-6 flex flex-col gap-4">
            <div>
              <h1 class="text-2xl font-bold text-base-content">{@artwork.name}</h1>
              <div class="flex flex-wrap gap-2 mt-2">
                <span :if={@artwork.style && @artwork.style != ""} class="badge badge-soft badge-primary">
                  {@artwork.style}
                </span>
                <span :if={@artwork.category && @artwork.category != ""} class="badge badge-soft badge-secondary">
                  {@artwork.category}
                </span>
                <span :if={@artwork.subcategory && @artwork.subcategory != ""} class="badge badge-soft badge-accent">
                  {@artwork.subcategory}
                </span>
              </div>
            </div>

            <p
              :if={@artwork.description && @artwork.description != ""}
              class="text-base-content/80 leading-relaxed"
            >
              {@artwork.description}
            </p>

            <%!-- Materiais --%>
            <div :if={@artwork.materials && @artwork.materials != ""} class="bg-base-200 rounded-xl p-4">
              <p class="text-xs font-semibold text-base-content/50 uppercase tracking-wider mb-1">Materiais</p>
              <p class="text-sm text-base-content/80">{@artwork.materials}</p>
            </div>

            <%!-- Dimensões e peso --%>
            <div class="grid grid-cols-2 gap-3">
              <div :if={@artwork.width} class="bg-base-200 rounded-xl p-3 text-center">
                <p class="text-xs text-base-content/50 uppercase tracking-wider">Largura</p>
                <p class="font-semibold text-base-content">{@artwork.width} cm</p>
              </div>
              <div :if={@artwork.height} class="bg-base-200 rounded-xl p-3 text-center">
                <p class="text-xs text-base-content/50 uppercase tracking-wider">Altura</p>
                <p class="font-semibold text-base-content">{@artwork.height} cm</p>
              </div>
              <div :if={@artwork.depth} class="bg-base-200 rounded-xl p-3 text-center">
                <p class="text-xs text-base-content/50 uppercase tracking-wider">Profundidade</p>
                <p class="font-semibold text-base-content">{@artwork.depth} cm</p>
              </div>
              <div :if={@artwork.weight} class="bg-base-200 rounded-xl p-3 text-center">
                <p class="text-xs text-base-content/50 uppercase tracking-wider">Peso</p>
                <p class="font-semibold text-base-content">{@artwork.weight} kg</p>
              </div>
            </div>

            <%!-- Preço --%>
            <div :if={@artwork.sent_price} class="mt-auto pt-2 border-t border-base-300">
              <p class="text-xs text-base-content/50 uppercase tracking-wider">Preço</p>
              <p class="text-2xl font-bold text-primary">
                R$ {:erlang.float_to_binary(@artwork.sent_price / 100, decimals: 2)}
              </p>
            </div>
          </div>
        </div>
      </div>

      <%!-- Seção de Opiniões --%>
      <div class="mt-10">
        <h2 class="text-xl font-bold text-base-content mb-4 flex items-center gap-2">
          <.icon name="hero-chat-bubble-left-ellipsis" class="w-5 h-5 text-primary" />
          Opiniões
        </h2>

        <div :if={@opinions == []} class="card bg-base-200 p-8 text-center">
          <p class="text-base-content/50">Nenhuma opinião pública ainda.</p>
        </div>

        <div class="flex flex-col gap-4">
          <div :for={opinion <- @opinions} class="card bg-base-100 shadow-sm p-5">
            <div class="flex items-center gap-2 mb-2">
              <div class="flex gap-0.5">
                <span :for={i <- 1..5}>
                  <.icon
                    name={if i <= opinion.ratin, do: "hero-star-solid", else: "hero-star"}
                    class={["w-4 h-4", if(i <= opinion.ratin, do: "text-warning", else: "text-base-content/20")]}
                  />
                </span>
              </div>
              <span class="text-xs text-base-content/40 ml-auto">
                {Calendar.strftime(opinion.inserted_at, "%d/%m/%Y")}
              </span>
            </div>
            <p class="text-sm text-base-content/80 leading-relaxed">{opinion.opinion_text}</p>
          </div>
        </div>
      </div>

      <%!-- Formulário de nova opinião (somente para usuários logados) --%>
      <.opinion_form_card
        :if={@opinion_form}
        form={@opinion_form}
        title="Deixe sua opinião"
        cancel_path={~p"/artworks/#{@artwork}"}
      />
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    artwork = Gallery.get_artwork!(id)
    opinions = Accounts.list_public_opinions_for_artwork(artwork.id)
    scope = socket.assigns[:current_scope]

    is_admin =
      scope && scope.user && scope.user.role == :admin

    opinion_form =
      if scope && scope.user do
        new_opinion = %Opinion{user_id: scope.user.id, artwork_id: artwork.id}
        to_form(Accounts.change_opinion(scope, new_opinion))
      end

    {:ok,
     socket
     |> assign(:page_title, artwork.name)
     |> assign(:artwork, artwork)
     |> assign(:opinions, opinions)
     |> assign(:is_admin, is_admin)
     |> assign(:opinion_form, opinion_form)}
  end

  @impl true
  def handle_event("validate", %{"opinion" => params}, socket) do
    scope = socket.assigns.current_scope
    opinion = %Opinion{user_id: scope.user.id, artwork_id: socket.assigns.artwork.id}
    params = Map.put(params, "artwork_id", socket.assigns.artwork.id)
    changeset = Accounts.change_opinion(scope, opinion, params)
    {:noreply, assign(socket, opinion_form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"opinion" => params}, socket) do
    scope = socket.assigns.current_scope
    params = Map.put(params, "artwork_id", socket.assigns.artwork.id)

    case Accounts.create_opinion(scope, params) do
      {:ok, _opinion} ->
        opinions = Accounts.list_public_opinions_for_artwork(socket.assigns.artwork.id)
        new_opinion = %Opinion{user_id: scope.user.id, artwork_id: socket.assigns.artwork.id}

        {:noreply,
         socket
         |> put_flash(:info, "Opinião publicada com sucesso")
         |> assign(:opinions, opinions)
         |> assign(:opinion_form, to_form(Accounts.change_opinion(scope, new_opinion)))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, opinion_form: to_form(changeset))}
    end
  end
end
