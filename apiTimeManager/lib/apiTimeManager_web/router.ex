defmodule ApiTimeManagerWeb.Router do
  use ApiTimeManagerWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", ApiTimeManagerWeb do
    pipe_through :api
    resources "/users", UserController, except: [:index]
    get "/users", UserController, :check
    options "/users/", UserController, :options
    options "/users/:userID", UserController, :options
    get "/allusers", UserController, :getallusers

    get "/workingtimes/:user_id", WorkingTimeController, :get_all
    get "/workingtimes/:user_id/:workingtimeID", WorkingTimeController, :get_one
    put "/workingtimes/:id", WorkingTimeController, :update
    post "/workingtimes/:user_id", WorkingTimeController, :create
    delete "/workingtimes/:id",WorkingTimeController, :delete

    post "/clocks/:user_id", ClockController, :create
    get "/clocks/:user_id", ClockController, :index
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through([:fetch_session, :protect_from_forgery])
      live_dashboard("/dashboard", metrics: ApiTimeManagerWeb.Telemetry)
    end
  end
end
