defmodule CalderaodeartesdavobruxaWeb.OpinionComponents do
  use Phoenix.Component

  import CalderaodeartesdavobruxaWeb.CoreComponents, only: [button: 1, translate_error: 1]

  @doc """
  Card de formulário de opinião com estrelas, textarea e toggle de visibilidade.

  ## Atributos

    * `form` - o `%Phoenix.HTML.Form{}` associado à opinião
    * `title` - título exibido no topo do card
    * `cancel_path` - caminho para o botão Cancelar
  """
  attr :form, Phoenix.HTML.Form, required: true
  attr :title, :string, required: true
  attr :cancel_path, :string, required: true

  def opinion_form_card(assigns) do
    ~H"""
    <div class="max-w-2xl mx-auto px-4 py-8">
      <div class="card bg-base-100 shadow-xl border border-base-300">
        <div class="card-body gap-6">
          <div>
            <h2 class="card-title text-xl">{@title}</h2>
            <p class="text-base-content/60 text-sm mt-1">Compartilhe sua experiência com esta obra.</p>
          </div>

          <.form for={@form} id="opinion-form" phx-change="validate" phx-submit="save" class="flex flex-col gap-6">
            <%!-- Rating em estrelas --%>
            <div class="flex flex-col gap-2">
              <label class="label-text font-semibold text-base">
                Avaliação
                <span class="text-base-content/50 font-normal ml-1">(obrigatório)</span>
              </label>
              <div class="rating rating-lg gap-1">
                <input
                  type="radio"
                  name={@form[:ratin].name}
                  value="0"
                  class="rating-hidden"
                  checked={(@form[:ratin].value || 0) == 0}
                />
                <%= for star <- 1..5 do %>
                  <input
                    type="radio"
                    name={@form[:ratin].name}
                    value={star}
                    aria-label={"#{star} estrela#{if star > 1, do: "s"}"}
                    class="mask mask-star-2 bg-warning cursor-pointer"
                    checked={to_string(@form[:ratin].value) == to_string(star)}
                  />
                <% end %>
              </div>
              <p :for={error <- @form[:ratin].errors} class="text-error text-sm mt-1">
                {translate_error(error)}
              </p>
            </div>

            <%!-- Texto da opinião --%>
            <div class="flex flex-col gap-2">
              <label class="label-text font-semibold text-base" for={@form[:opinion_text].id}>
                Sua opinião
                <span class="text-base-content/50 font-normal ml-1">(obrigatório)</span>
              </label>
              <textarea
                id={@form[:opinion_text].id}
                name={@form[:opinion_text].name}
                rows="8"
                placeholder="Escreva livremente o que sentiu, pensou ou experienciou ao contemplar esta obra..."
                class="textarea textarea-bordered w-full text-base leading-relaxed resize-y min-h-[180px]"
                phx-debounce="blur"
              >{@form[:opinion_text].value}</textarea>
              <p :for={error <- @form[:opinion_text].errors} class="text-error text-sm mt-1">
                {translate_error(error)}
              </p>
            </div>

            <%!-- Visibilidade (public) --%>
            <div class="flex flex-col gap-2">
              <label class="label cursor-pointer justify-start gap-4 p-4 rounded-xl border border-base-300 bg-base-200 hover:bg-base-300 transition-colors">
                <input
                  type="hidden"
                  name={@form[:public].name}
                  value="false"
                />
                <input
                  type="checkbox"
                  id={@form[:public].id}
                  name={@form[:public].name}
                  value="true"
                  class="toggle toggle-primary"
                  checked={@form[:public].value in [true, "true"]}
                />
                <div>
                  <p class="label-text font-semibold text-base">Tornar opinião pública</p>
                  <p class="text-base-content/60 text-sm mt-0.5">
                    Quando ativado, sua opinião ficará visível para todos os visitantes.
                    <br />
                    Caso contrário, apenas os administradores poderão lê-la.
                  </p>
                </div>
              </label>
              <p :for={error <- @form[:public].errors} class="text-error text-sm mt-1">
                {translate_error(error)}
              </p>
            </div>

            <footer class="flex gap-3 pt-2">
              <.button phx-disable-with="Salvando..." variant="primary">Publicar opinião</.button>
              <.button navigate={@cancel_path}>Cancelar</.button>
            </footer>
          </.form>
        </div>
      </div>
    </div>
    """
  end
end
