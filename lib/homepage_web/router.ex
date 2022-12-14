defmodule HomepageWeb.Router do
  use HomepageWeb, :router

  import HomepageWeb.UserAuth

  pipeline :browser do
    plug HomepageWeb.Plugs.RedirectPlug
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {HomepageWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HomepageWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/blog/:id", PageController, :show
    get "/about", PageController, :about
    get "/feed/rss.xml", RssController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", HomepageWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: HomepageWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", HomepageWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
  end

  scope "/", HomepageWeb do
    pipe_through [:browser, :require_authenticated_user]

    live "/posts", PostLive.Index, :index
    live "/posts/new", PostLive.Index, :new
    live "/posts/:id/edit", PostLive.Index, :edit

    live "/posts/:id", PostLive.Show, :show
    live "/posts/:id/show/edit", PostLive.Show, :edit

    live "/images", ImageLive.Index, :index
    live "/images/new", ImageLive.Index, :new
    live "/images/:id/edit", ImageLive.Index, :edit

    live "/images/:id", ImageLive.Show, :show
    live "/images/:id/show/edit", ImageLive.Show, :edit
  end

  scope "/", HomepageWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
  end
end
