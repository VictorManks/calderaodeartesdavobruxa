defmodule CalderaodeartedavobruxaWeb.Router do
  use CalderaodeartedavobruxaWeb, :router

  import CalderaodeartedavobruxaWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {CalderaodeartedavobruxaWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_scope_for_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :require_admin do
    plug :require_authenticated_user
    plug :require_admin_user
  end

  scope "/", CalderaodeartedavobruxaWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/", CalderaodeartedavobruxaWeb do
    pipe_through [:browser, :require_admin]

    live_session :require_admin,
      on_mount: [{CalderaodeartedavobruxaWeb.UserAuth, :require_admin}] do

      live "/artworks/new", ArtworkLive.Form, :new
      live "/artworks/:id/edit", ArtworkLive.Form, :edit
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", CalderaodeartedavobruxaWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:calderaodeartedavobruxa, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: CalderaodeartedavobruxaWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", CalderaodeartedavobruxaWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{CalderaodeartedavobruxaWeb.UserAuth, :require_authenticated}] do
      live "/users/settings", UserLive.Settings, :edit
      live "/users/settings/confirm-email/:token", UserLive.Settings, :confirm_email

      live "/opinions", OpinionLive.Index, :index
      live "/opinions/new", OpinionLive.Form, :new
      live "/opinions/:id", OpinionLive.Show, :show
      live "/opinions/:id/edit", OpinionLive.Form, :edit
    end

    post "/users/update-password", UserSessionController, :update_password
  end

  scope "/", CalderaodeartedavobruxaWeb do
    pipe_through [:browser]

    live_session :current_user,
      on_mount: [{CalderaodeartedavobruxaWeb.UserAuth, :mount_current_scope}] do
      live "/users/register", UserLive.Registration, :new
      live "/users/log-in", UserLive.Login, :new
      live "/users/log-in/:token", UserLive.Confirmation, :new

      live "/artworks", ArtworkLive.Index, :index
      live "/artworks/:id", ArtworkLive.Show, :show
    end

    post "/users/log-in", UserSessionController, :create
    delete "/users/log-out", UserSessionController, :delete
  end
end
