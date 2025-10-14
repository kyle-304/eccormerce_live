defmodule EcommerceLiveWeb.Router do
  use EcommerceLiveWeb, :router

  import EcommerceLiveWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {EcommerceLiveWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_scope_for_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :admin do
    plug :require_authenticated_user
    plug :require_admin_user
  end

  defp require_admin_user(conn, _opts) do
    # Fix: safely fetch current_user whether it’s assigned directly or inside current_scope
    user =
      conn.assigns[:current_user] ||
        (conn.assigns[:current_scope] && conn.assigns[:current_scope].user)

    cond do
      user && user.role in [:admin, "admin"] ->
        # Ensure we assign it as current_user for LiveViews, etc.
        assign(conn, :current_user, user)

      user ->
        conn
        |> put_flash(:error, "Access Denied")
        |> redirect(to: "/")
        |> halt()

      true ->
        conn
        |> put_flash(:error, "Please log in")
        |> redirect(to: "/users/log_in")
        |> halt()
    end
  end

  scope "/", EcommerceLiveWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", EcommerceLiveWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:ecommerce_live, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: EcommerceLiveWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", EcommerceLiveWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{EcommerceLiveWeb.UserAuth, :require_authenticated}] do
      live "/users/settings", UserLive.Settings, :edit
      live "/users/settings/confirm-email/:token", UserLive.Settings, :confirm_email
    end

    post "/users/update-password", UserSessionController, :update_password
  end

  scope "/", EcommerceLiveWeb do
    pipe_through [:browser]

    live_session :current_user,
      on_mount: [{EcommerceLiveWeb.UserAuth, :mount_current_scope}] do
      live "/users/register", UserLive.Registration, :new
      live "/users/log-in", UserLive.Login, :new
      live "/users/log-in/:token", UserLive.Confirmation, :new
    end

    post "/users/log-in", UserSessionController, :create
    delete "/users/log-out", UserSessionController, :delete
  end

  scope "/admin", EcommerceLiveWeb.Admin, as: :admin do
    pipe_through [:browser, :admin]

    # Dashboard (optional)
    # live "/dashboard", DashboardLive, :index

    # Categories
    live "/categories", CategoryLive.Index, :index
    live "/categories/new", CategoryLive.New, :new
    live "/categories/:id", CategoryLive.Show, :show
    live "/categories/:id/edit", CategoryLive.Edit, :edit

    # Products
    live "/products", ProductLive.Index, :index
    live "/products/new", ProductLive.Form, :new
    live "/products/:id/edit", ProductLive.Form, :edit
    live "/products/:id", ProductLive.Show, :show

    # Orders (if you have admin order management)
    # live "/orders", OrderLive.Index, :index
    # live "/orders/:id", OrderLive.Show, :show
  end
end
