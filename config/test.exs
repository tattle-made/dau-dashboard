import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :dau, DAU.Repo,
  username: "tattle",
  password: "weak_password",
  hostname: "localhost",
  database: "dau_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :dau, DAUWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "lnzjP5rBM4kX2GwxqnM7Un2VPedrpcPqQ+AyistdFIymDK7d0YtfKjlbp6u3+vac",
  server: false

# In test we don't send emails.
config :dau, DAU.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :dau, RabbitMQ, url: "amqp://admin:Admin123@localhost"

config :dau, :aws_client, AWSS3.Sandbox

config :dau, :gupshup_client, DAU.UserMessage.MessageDelivery.Sandbox
