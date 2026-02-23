defmodule CalderaodeartedavobruxaWeb.OpinionLive.Show do
  use CalderaodeartedavobruxaWeb, :live_view

  alias Calderaodeartedavobruxa.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Opinion {@opinion.id}
        <:subtitle>This is a opinion record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/opinions"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/opinions/#{@opinion}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit opinion
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Ratin">{@opinion.ratin}</:item>
        <:item title="Opinion text">{@opinion.opinion_text}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket) do
      Accounts.subscribe_opinions(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Show Opinion")
     |> assign(:opinion, Accounts.get_opinion!(socket.assigns.current_scope, id))}
  end

  @impl true
  def handle_info(
        {:updated, %Calderaodeartedavobruxa.Accounts.Opinion{id: id} = opinion},
        %{assigns: %{opinion: %{id: id}}} = socket
      ) do
    {:noreply, assign(socket, :opinion, opinion)}
  end

  def handle_info(
        {:deleted, %Calderaodeartedavobruxa.Accounts.Opinion{id: id}},
        %{assigns: %{opinion: %{id: id}}} = socket
      ) do
    {:noreply,
     socket
     |> put_flash(:error, "The current opinion was deleted.")
     |> push_navigate(to: ~p"/opinions")}
  end

  def handle_info({type, %Calderaodeartedavobruxa.Accounts.Opinion{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, socket}
  end
end
