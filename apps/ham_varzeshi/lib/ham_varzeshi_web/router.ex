defmodule HamVarzeshiWeb.Router do
  use HamVarzeshiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug HamVarzeshiWeb.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HamVarzeshiWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/users", UserController, only: [:index, :show, :new, :create, :delete]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    resources "/edit", UserController, only: [:edit, :update]
  end

  scope "/manage", HamVarzeshiWeb do
    pipe_through [:browser, :authenticate_user]

    resources "/gyms", GymController, only: [:index, :show, :new, :create, :delete, :edit, :update]
  end

  # Other scopes may use custom stacks.
  # scope "/api", HamVarzeshiWeb do
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
      live_dashboard "/dashboard", metrics: HamVarzeshiWeb.Telemetry
    end
  end
end
