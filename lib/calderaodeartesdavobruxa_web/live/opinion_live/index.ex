defmodule CalderaodeartesdavobruxaWeb.OpinionLive.Index do
  use CalderaodeartesdavobruxaWeb, :live_view

  alias Calderaodeartesdavobruxa.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="max-w-3xl mx-auto px-4 py-8">

        <div class="flex items-center justify-between mb-6">
          <h1 class="text-2xl font-bold text-base-content">Minhas Opiniões</h1>
        </div>

        <div id="opinions" class="flex flex-col gap-4" phx-update="stream">
          <div :for={{dom_id, opinion} <- @streams.opinions} id={dom_id}>
            <div class="card bg-base-100 shadow-sm border border-base-300 hover:shadow-md transition-shadow duration-200">
              <div class="card-body p-4 flex flex-row gap-4 items-start">

                <%!-- Thumbnail da obra --%>
                <.link navigate={~p"/artworks/#{opinion.artwork_id}"} class="shrink-0 group">
                  <div class="w-20 h-20 rounded-xl overflow-hidden bg-base-200 flex items-center justify-center ring-2 ring-transparent group-hover:ring-primary transition-all duration-200">
                    <img
                      :if={opinion.artwork && opinion.artwork.img && opinion.artwork.img != ""}
                      src={opinion.artwork.img}
                      alt={opinion.artwork && opinion.artwork.name}
                      class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-200"
                    />
                    <.icon
                      :if={!opinion.artwork || !opinion.artwork.img || opinion.artwork.img == ""}
                      name="hero-photo"
                      class="w-8 h-8 text-base-content/30"
                    />
                  </div>
                </.link>

                <%!-- Conteúdo --%>
                <div class="flex-1 min-w-0">
                  <div class="flex items-start justify-between gap-2 flex-wrap">
                    <div>
                      <.link
                        navigate={~p"/artworks/#{opinion.artwork_id}"}
                        class="font-semibold text-base-content text-sm hover:text-primary hover:underline underline-offset-2 transition-colors duration-150"
                      >
                        {opinion.artwork && opinion.artwork.name}
                      </.link>
                      <div class="flex gap-0.5 mt-1">
                        <span :for={i <- 1..5}>
                          <.icon
                            name={if i <= opinion.ratin, do: "hero-star-solid", else: "hero-star"}
                            class={["w-3.5 h-3.5", if(i <= opinion.ratin, do: "text-warning", else: "text-base-content/20")]}
                          />
                        </span>
                      </div>
                    </div>
                    <div class="flex items-center gap-2 shrink-0">
                      <span :if={opinion.public} class="badge badge-soft badge-success badge-sm">Pública</span>
                      <span :if={!opinion.public} class="badge badge-soft badge-neutral badge-sm">Privada</span>
                      <.link navigate={~p"/opinions/#{opinion}/edit"} class="btn btn-ghost btn-xs" title="Editar">
                        <.icon name="hero-pencil-square" class="w-4 h-4" />
                      </.link>
                      <button
                        phx-click={JS.push("delete", value: %{id: opinion.id}) |> hide("##{dom_id}")}
                        data-confirm="Tem certeza que deseja excluir esta opinião?"
                        class="btn btn-ghost btn-xs text-error"
                        title="Excluir"
                      >
                        <.icon name="hero-trash" class="w-4 h-4" />
                      </button>
                    </div>
                  </div>
                  <p class="text-sm text-base-content/70 mt-2 line-clamp-2 leading-relaxed">
                    {opinion.opinion_text}
                  </p>
                  <p class="text-xs text-base-content/40 mt-2">
                    {Calendar.strftime(opinion.inserted_at, "%d/%m/%Y")}
                  </p>
                </div>

              </div>
            </div>
          </div>
        </div>

      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Accounts.subscribe_opinions(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Listing Opinions")
     |> stream(:opinions, list_opinions(socket.assigns.current_scope))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    opinion = Accounts.get_opinion!(socket.assigns.current_scope, id)
    {:ok, _} = Accounts.delete_opinion(socket.assigns.current_scope, opinion)

    {:noreply, stream_delete(socket, :opinions, opinion)}
  end

  @impl true
  def handle_info({type, %Calderaodeartesdavobruxa.Accounts.Opinion{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, stream(socket, :opinions, list_opinions(socket.assigns.current_scope), reset: true)}
  end

  defp list_opinions(current_scope) do
    Accounts.list_opinions(current_scope)
  end
end
