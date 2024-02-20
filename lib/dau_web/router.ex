defmodule DAUWeb.Router do
  use DAUWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {DAUWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DAUWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/gupshup", DAUWeb do
    pipe_through :api

    resources "/message", IncomingMessageController, except: [:edit, :delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", DAUWeb do
  #   pipe_through :api
  # end

  scope "/canon", DAUWeb do
    pipe_through :browser

    live "/manipulated_media", ManipulatedMediaLive.Index, :index
    live "/manipulated_media/new", ManipulatedMediaLive.Index, :new
    live "/manipulated_media/:id/edit", ManipulatedMediaLive.Index, :edit

    live "/manipulated_media/:id", ManipulatedMediaLive.Show, :show
    live "/manipulated_media/:id/show/edit", ManipulatedMediaLive.Show, :edit

    live "/factcheck_articles", FactcheckArticleLive.Index, :index
    live "/factcheck_articles/new", FactcheckArticleLive.Index, :new
    live "/factcheck_articles/:id/edit", FactcheckArticleLive.Index, :edit

    live "/factcheck_articles/:id", FactcheckArticleLive.Show, :show
    live "/factcheck_articles/:id/show/edit", FactcheckArticleLive.Show, :edit

    live "/analysis", AnalysisLive.Index, :index
    live "/analysis/new", AnalysisLive.Index, :new
    live "/analysis/:id/edit", AnalysisLive.Index, :edit

    live "/analysis/:id", AnalysisLive.Show, :show
    live "/analysis/:id/show/edit", AnalysisLive.Show, :edit
  end

  scope "verification", DAU do
    live "/queries", QueryLive.Index, :index
    live "/queries/new", QueryLive.Index, :new
    live "/queries/:id/edit", QueryLive.Index, :edit

    live "/queries/:id", QueryLive.Show, :show
    live "/queries/:id/show/edit", QueryLive.Show, :edit

    live "/comments", CommentLive.Index, :index
    live "/comments/new", CommentLive.Index, :new
    live "/comments/:id/edit", CommentLive.Index, :edit

    live "/comments/:id", CommentLive.Show, :show
    live "/comments/:id/show/edit", CommentLive.Show, :edit

    live "/response", ResponseLive.Index, :index
    live "/response/new", ResponseLive.Index, :new
    live "/response/:id/edit", ResponseLive.Index, :edit

    live "/response/:id", ResponseLive.Show, :show
    live "/response/:id/show/edit", ResponseLive.Show, :edit
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:dau, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: DAUWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
