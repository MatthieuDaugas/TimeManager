use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :apiTimeManager, ApiTimeManager.Repo,
  username: "postgres",
  password: "root",
  database: "apitimemanager_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox


if System.get_env("GITHUB_ACTIONS") do
  config :my_app, MyApp.Repo,
    username: "postgres",
    password: "postgres"
end
# We don't run a server during test. If one is required,
# you can enable the server option below.
config :apiTimeManager, ApiTimeManagerWeb.Endpoint,
  http: [port: 4000],
  server: true

# Print only warnings and errors during test
config :logger, level: :warn
