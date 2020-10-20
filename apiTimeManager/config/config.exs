# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :apiTimeManager,
  ecto_repos: [ApiTimeManager.Repo]

# Configures the endpoint
config :apiTimeManager, ApiTimeManagerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "6C9DcZWNx1JB5FwNUD40iFTh2Uj2we6/d8ZHdB8TSQzJohdAdMdH4hDl6SyPDqqX",
  render_errors: [view: ApiTimeManagerWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: ApiTimeManager.PubSub,
  live_view: [signing_salt: "Cpj8P2go"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
