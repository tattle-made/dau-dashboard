defmodule DAUWeb.Router do
  use DAUWeb, :router

  import DAUWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {DAUWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DAUWeb do
    pipe_through :browser

    get "/", PageController, :home
    live "/outbox", SearchLive.Outbox
  end

  scope "/gupshup", DAUWeb do
    pipe_through :api

    resources "/message", IncomingMessageController, except: [:edit, :delete]
    post "/delivery-report", IncomingMessageController, :receive_delivery_report
    # post "/sender", UserMessagePreferenceController, :create
    # post "/sender/preference", UserMessagePreferenceController, :fetch
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

  scope "/verification", DAUWeb do
    pipe_through :browser

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

  scope "/demo", DAUWeb do
    pipe_through :browser

    live "/query/", SearchLive.Index
    live "/query/verification/:id", SearchLive.Verification
    live "/query/:id", SearchLive.Detail
    live "/query/components", SearchLive.Component
    live "/query/:id/user-response/", SearchLive.UserResponse
    get "/query/:id/queries", QueryController, :index
  end

  scope "/admin", DAUWeb do
    import Phoenix.LiveDashboard.Router
    pipe_through [:browser, :require_authenticated_user]

    live_dashboard "/dashboard", metrics: DAUWeb.Telemetry
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:dau, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).

    scope "/dev" do
      pipe_through :browser

      # live_dashboard "/dashboard", metrics: DAUWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", DAUWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{DAUWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", DAUWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{DAUWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end
  end

  scope "/", DAUWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{DAUWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
