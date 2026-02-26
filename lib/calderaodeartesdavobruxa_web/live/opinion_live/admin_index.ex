defmodule CalderaodeartesdavobruxaWeb.OpinionLive.AdminIndex do
  use CalderaodeartesdavobruxaWeb, :live_view

  alias Calderaodeartesdavobruxa.Accounts

  @per_page 20

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="max-w-4xl mx-auto px-4 py-8">

        <div class="flex items-center justify-between mb-6">
          <div>
            <h1 class="text-2xl font-bold text-base-content">Todas as Opiniões</h1>
            <p class="text-sm text-base-content/50 mt-1">{@total} opiniões no total</p>
          </div>
        </div>

        <div class="overflow-x-auto rounded-xl border border-base-300 shadow-sm">
          <table class="table table-zebra w-full">
            <thead>
              <tr class="bg-base-200 text-base-content/70 text-xs uppercase tracking-wider">
                <th>Obra</th>
                <th>Opinião</th>
                <th class="text-center">Nota</th>
                <th class="text-center">Visível</th>
                <th>Data</th>
              </tr>
            </thead>
            <tbody>
              <tr :for={opinion <- @opinions} class="hover:bg-base-200 transition-colors">
                <td class="max-w-[160px]">
                  <.link
                    navigate={~p"/artworks/#{opinion.artwork_id}"}
                    class="font-medium text-sm hover:text-primary hover:underline underline-offset-2 transition-colors duration-150 line-clamp-2"
                  >
                    {opinion.artwork && opinion.artwork.name}
                  </.link>
                </td>
                <td class="max-w-[280px]">
                  <p class="text-sm text-base-content/80 line-clamp-2">{opinion.opinion_text}</p>
                </td>
                <td class="text-center">
                  <div class="flex justify-center gap-0.5">
                    <span :for={i <- 1..5}>
                      <.icon
                        name={if i <= opinion.ratin, do: "hero-star-solid", else: "hero-star"}
                        class={["w-3.5 h-3.5", if(i <= opinion.ratin, do: "text-warning", else: "text-base-content/20")]}
                      />
                    </span>
                  </div>
                </td>
                <td class="text-center">
                  <span :if={opinion.public} class="badge badge-soft badge-success badge-sm">Pública</span>
                  <span :if={!opinion.public} class="badge badge-soft badge-neutral badge-sm">Privada</span>
                </td>
                <td class="text-xs text-base-content/50 whitespace-nowrap">
                  {Calendar.strftime(opinion.inserted_at, "%d/%m/%Y")}
                </td>
              </tr>
              <tr :if={@opinions == []}>
                <td colspan="6" class="text-center py-12 text-base-content/40">
                  Nenhuma opinião encontrada.
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <%!-- Paginação --%>
        <div :if={@total_pages > 1} class="flex justify-center items-center gap-2 mt-6">
          <.link
            :if={@page > 1}
            patch={~p"/admin/opinions?page=#{@page - 1}"}
            class="btn btn-ghost btn-sm"
          >
            <.icon name="hero-chevron-left" class="w-4 h-4" />
          </.link>

          <span :for={p <- pages_range(@page, @total_pages)}>
            <.link
              :if={p != :ellipsis}
              patch={~p"/admin/opinions?page=#{p}"}
              class={["btn btn-sm", if(p == @page, do: "btn-primary", else: "btn-ghost")]}
            >
              {p}
            </.link>
            <span :if={p == :ellipsis} class="px-1 text-base-content/40">…</span>
          </span>

          <.link
            :if={@page < @total_pages}
            patch={~p"/admin/opinions?page=#{@page + 1}"}
            class="btn btn-ghost btn-sm"
          >
            <.icon name="hero-chevron-right" class="w-4 h-4" />
          </.link>
        </div>

      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    page = max(1, String.to_integer(params["page"] || "1"))
    %{opinions: opinions, total: total} = Accounts.list_all_opinions(page, @per_page)
    total_pages = ceil(total / @per_page)

    {:noreply,
     socket
     |> assign(:page_title, "Admin — Opiniões")
     |> assign(:page, page)
     |> assign(:total, total)
     |> assign(:total_pages, total_pages)
     |> assign(:opinions, opinions)}
  end

  defp pages_range(current, total) when total <= 7 do
    Enum.to_list(1..total)
  end

  defp pages_range(current, total) do
    cond do
      current <= 4 ->
        Enum.to_list(1..5) ++ [:ellipsis, total]

      current >= total - 3 ->
        [1, :ellipsis] ++ Enum.to_list((total - 4)..total)

      true ->
        [1, :ellipsis] ++ Enum.to_list((current - 1)..(current + 1)) ++ [:ellipsis, total]
    end
  end
end
