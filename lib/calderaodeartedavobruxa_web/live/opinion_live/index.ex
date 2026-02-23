defmodule CalderaodeartedavobruxaWeb.OpinionLive.Index do
  use CalderaodeartedavobruxaWeb, :live_view

  alias Calderaodeartedavobruxa.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Listing Opinions
        <:actions>
          <.button variant="primary" navigate={~p"/opinions/new"}>
            <.icon name="hero-plus" /> New Opinion
          </.button>
        </:actions>
      </.header>

      <.table
        id="opinions"
        rows={@streams.opinions}
        row_click={fn {_id, opinion} -> JS.navigate(~p"/opinions/#{opinion}") end}
      >
        <:col :let={{_id, opinion}} label="Ratin">{opinion.ratin}</:col>
        <:col :let={{_id, opinion}} label="Opinion text">{opinion.opinion_text}</:col>
        <:action :let={{_id, opinion}}>
          <div class="sr-only">
            <.link navigate={~p"/opinions/#{opinion}"}>Show</.link>
          </div>
          <.link navigate={~p"/opinions/#{opinion}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, opinion}}>
          <.link
            phx-click={JS.push("delete", value: %{id: opinion.id}) |> hide("##{id}")}
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
  def handle_info({type, %Calderaodeartedavobruxa.Accounts.Opinion{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, stream(socket, :opinions, list_opinions(socket.assigns.current_scope), reset: true)}
  end

  defp list_opinions(current_scope) do
    Accounts.list_opinions(current_scope)
  end
end
