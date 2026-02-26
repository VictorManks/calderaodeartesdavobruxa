defmodule CalderaodeartesdavobruxaWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use CalderaodeartesdavobruxaWeb, :html

  # Embed all files in layouts/* within this module.
  # The default root.html.heex file contains the HTML
  # skeleton of your application, namely HTML headers
  # and other static content.
  embed_templates "layouts/*"

  @doc """
  Renders your app layout.

  This function is typically invoked from every template,
  and it often contains your application menu, sidebar,
  or similar.

  ## Examples

      <Layouts.app flash={@flash}>
        <h1>Content</h1>
      </Layouts.app>

  """
  attr :flash, :map, required: true, doc: "the map of flash messages"

  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"

  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <main class="px-4 py-4 sm:px-6 lg:px-8">
      <div class="mx-auto max-w-7xl space-y-4">
        {render_slot(@inner_block)}
      </div>
    </main>

    <.flash_group flash={@flash} />
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def flash_group(assigns) do
    ~H"""
    <div id={@id} aria-live="polite">
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />

      <.flash
        id="client-error"
        kind={:error}
        title={gettext("We can't find the internet")}
        phx-disconnected={show(".phx-client-error #client-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#client-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={gettext("Something went wrong!")}
        phx-disconnected={show(".phx-server-error #server-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#server-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>
    </div>
    """
  end

  @doc """
  Provides dark vs light theme toggle based on themes defined in app.css.

  See <head> in root.html.heex which applies the theme before page load.
  """
  def theme_toggle(assigns) do
    ~H"""
    <div
      id="theme-toggle"
      class="flex items-center gap-1 bg-base-300 rounded-full p-1"
      phx-hook=".ThemeToggleSync"
    >
      <label class="tooltip tooltip-bottom" data-tip="Sistema">
        <input
          type="radio"
          name="theme-toggle-radio"
          class="theme-controller btn btn-xs btn-ghost btn-square rounded-full border-0 checked:bg-base-100"
          aria-label="💻"
          value="system"
        />
      </label>
      <label class="tooltip tooltip-bottom" data-tip="Claro">
        <input
          type="radio"
          name="theme-toggle-radio"
          class="theme-controller btn btn-xs btn-ghost btn-square rounded-full border-0 checked:bg-base-100"
          aria-label="☀️"
          value="light"
        />
      </label>
      <label class="tooltip tooltip-bottom" data-tip="Escuro">
        <input
          type="radio"
          name="theme-toggle-radio"
          class="theme-controller btn btn-xs btn-ghost btn-square rounded-full border-0 checked:bg-base-100"
          aria-label="🌙"
          value="dark"
        />
      </label>
    </div>
    <script :type={Phoenix.LiveView.ColocatedHook} name=".ThemeToggleSync">
      export default {
        mounted() {
          // Sincroniza os radios com o data-theme atual
          const sync = () => {
            const current = document.documentElement.getAttribute("data-theme") || "system";
            this.el.querySelectorAll("input[type=radio]").forEach(r => {
              r.checked = r.value === current;
            });
          };
          sync();

          // Persiste e aplica o tema ao mudar o radio
          this.el.addEventListener("change", (e) => {
            const theme = e.target.value;
            if (theme === "system") {
              localStorage.removeItem("phx:theme");
              document.documentElement.removeAttribute("data-theme");
            } else {
              localStorage.setItem("phx:theme", theme);
              document.documentElement.setAttribute("data-theme", theme);
            }
            sync();
          });

          // Observa mudanças externas no data-theme (ex: outro toggle)
          this._observer = new MutationObserver(sync);
          this._observer.observe(document.documentElement, { attributes: true, attributeFilter: ["data-theme"] });
        },
        destroyed() {
          if (this._observer) this._observer.disconnect();
        }
      }
    </script>
    """
  end
end
