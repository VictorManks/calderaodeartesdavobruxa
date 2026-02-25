defmodule CalderaodeartesdavobruxaWeb.OpinionLive.Form do
  use CalderaodeartesdavobruxaWeb, :live_view

  alias Calderaodeartesdavobruxa.Accounts
  alias Calderaodeartesdavobruxa.Accounts.Opinion

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage opinion records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="opinion-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:ratin]} type="number" label="Ratin" />
        <.input field={@form[:opinion_text]} type="textarea" label="Opinion text" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Opinion</.button>
          <.button navigate={return_path(@current_scope, @return_to, @opinion)}>Cancel</.button>
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
    opinion = Accounts.get_opinion!(socket.assigns.current_scope, id)

    socket
    |> assign(:page_title, "Edit Opinion")
    |> assign(:opinion, opinion)
    |> assign(:form, to_form(Accounts.change_opinion(socket.assigns.current_scope, opinion)))
  end

  defp apply_action(socket, :new, _params) do
    opinion = %Opinion{user_id: socket.assigns.current_scope.user.id}

    socket
    |> assign(:page_title, "New Opinion")
    |> assign(:opinion, opinion)
    |> assign(:form, to_form(Accounts.change_opinion(socket.assigns.current_scope, opinion)))
  end

  @impl true
  def handle_event("validate", %{"opinion" => opinion_params}, socket) do
    changeset = Accounts.change_opinion(socket.assigns.current_scope, socket.assigns.opinion, opinion_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"opinion" => opinion_params}, socket) do
    save_opinion(socket, socket.assigns.live_action, opinion_params)
  end

  defp save_opinion(socket, :edit, opinion_params) do
    case Accounts.update_opinion(socket.assigns.current_scope, socket.assigns.opinion, opinion_params) do
      {:ok, opinion} ->
        {:noreply,
         socket
         |> put_flash(:info, "Opinion updated successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, opinion)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_opinion(socket, :new, opinion_params) do
    case Accounts.create_opinion(socket.assigns.current_scope, opinion_params) do
      {:ok, opinion} ->
        {:noreply,
         socket
         |> put_flash(:info, "Opinion created successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, opinion)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path(_scope, "index", _opinion), do: ~p"/opinions"
  defp return_path(_scope, "show", opinion), do: ~p"/opinions/#{opinion}"
end
