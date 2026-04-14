defmodule DAUWeb.Router do
  use DAUWeb, :router
  import DAUWeb.UserAuth
  alias DAUWeb.LiveRouteAuthorization, as: LiveAuth

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

  pipeline :allow_driveby_user do
    plug DAUWeb.Plugs.RouteAuthorizationPlug, permission: :allow_driveby_user
  end

  pipeline :deny_driveby_user do
    plug DAUWeb.Plugs.RouteAuthorizationPlug, permission: :deny_driveby_user
  end

  # Open Routes, no Authorization or Authentication is Required
  scope "/", DAUWeb do
    pipe_through :browser

    get "/", PageController, :home
    live "/datasets/terms-of-use", TermsOfUseLive, :index
    # live "/outbox", SearchLive.Outbox
  end

  # Open Datasets Routes. Require only Authentication. Anyone who is logged-in can access these.
  scope "/datasets", DAUWeb do
    pipe_through [:browser, :require_authenticated_user, :allow_driveby_user]

    live_session :open_data,
      on_mount: [
        {DAUWeb.UserAuth, :ensure_authenticated},
        {LiveAuth, :allow_driveby_user}
      ] do
      live "/", OpenDataLive.OpenDataIndexLive, :index
      live "/preview/whatsapp-tipline-dataset", OpenDataLive.FeedOpenLive, :index
      live "/preview/escalations", OpenDataLive.OtherSourcesOpenLive, :index
    end
  end

  # This endpoint receives form submission data from Google Forms via an Apps Script trigger whenever a user submits a response.
  # scope "/external-escalations", DAUWeb do
  #   pipe_through :api
  #   post "/", ExternalEscalationController, :create
  # end

  # Webhook endpoint to get Slack events
  scope "/slack", DAUWeb do
    pipe_through :api
    post "/", SlackController, :create
  end

  # Liveview to display Slack archives and external escalations
  scope "/", DAUWeb do
    pipe_through [:browser, :require_authenticated_user, :deny_driveby_user]

    live_session :slack_archives,
      on_mount: [
        {DAUWeb.UserAuth, :ensure_authenticated},
        {LiveAuth, :deny_driveby_user}
      ] do
      live "/slack-archives", SlackArchivesHomeLive, :index
      live "/external-escalations", ViewExternalEscalationsLive, :index
    end
  end

  # Webhook endpoint to receive data from the WhatsApp BSP.
  scope "/gupshup", DAUWeb do
    pipe_through :api

    resources "/message", IncomingMessageController, except: [:index, :edit, :delete]
    post "/delivery-report", IncomingMessageController, :receive_delivery_report
    # post "/sender", UserMessagePreferenceController, :create
    # post "/sender/preference", UserMessagePreferenceController, :fetch
  end

  # Other scopes may use custom stacks.
  # scope "/api", DAUWeb do
  #   pipe_through :api
  # end

  # Liveview routes to work with the WhatsApp tipline data. Only Authorized users are allowed to access these routes.
  scope "/demo", DAUWeb do
    pipe_through [:browser, :require_authenticated_user, :deny_driveby_user]

    live_session :demo,
      on_mount: [
        {DAUWeb.UserAuth, :ensure_authenticated},
        {LiveAuth, :deny_driveby_user}
      ] do
      live "/query/", SearchLive.Index
      live "/query/verification/:id", SearchLive.Verification
      live "/query/:id", SearchLive.Detail
      live "/query/:id/user-response/", SearchLive.UserResponse
    end

    get "/query/:id/matches", MatchesController, :index
    get "/query/:id/assessment-report/metadata", AssessmentReportMetadataController, :show
    get "/query/assessment-report/metadata", AssessmentReportMetadataController, :fetch
    get "/query/:id/assessment-report/metadata/edit", AssessmentReportMetadataController, :edit
    put "/query/:id/assessment-report/metadata/edit", AssessmentReportMetadataController, :update
    post "/query/:id/assessment-report/metadata", AssessmentReportMetadataController, :create

    delete "/query/:id/assessment-report/metadata/delete",
           AssessmentReportMetadataController,
           :delete
  end

  scope "/admin", DAUWeb do
    import Phoenix.LiveDashboard.Router
    pipe_through [:browser, :require_authenticated_user, :deny_driveby_user]

    live_dashboard "/dashboard",
      metrics: DAUWeb.Telemetry,
      on_mount: [
        {DAUWeb.UserAuth, :ensure_authenticated},
        {LiveAuth, :deny_driveby_user}
      ]
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
      layout: false,
      on_mount: [{DAUWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  # Setting routes. Require Authentication.
  scope "/", DAUWeb do
    pipe_through [:browser, :require_authenticated_user, :allow_driveby_user]

    live_session :user_settings,
      on_mount: [
        {DAUWeb.UserAuth, :ensure_authenticated},
        {LiveAuth, :allow_driveby_user}
      ] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end
  end

  scope "/", DAUWeb do
    pipe_through [:browser, :require_authenticated_user, :deny_driveby_user]

    live_session :user_outbox,
      on_mount: [
        {DAUWeb.UserAuth, :ensure_authenticated},
        {LiveAuth, :deny_driveby_user}
      ] do
      live "/outbox", SearchLive.Outbox
    end
  end

  # User confirmation and logout routes - no authentication required
  scope "/", DAUWeb do
    pipe_through :browser

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{DAUWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/landing", UserConfirmationLandingLive, :index
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end

  scope "/analytics", DAUWeb do
    pipe_through [:browser, :require_authenticated_user, :deny_driveby_user]

    get "/", AnalyticsController, :hello_world
  end
end
