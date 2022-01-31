import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :pickle, Pickle.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "pickle_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :pickle, PickleWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "N/XeRGoZ44Wg7ORulqex5FdgvesjozFN/F/J7S04bywH6a82Scx0hsC7eCzZPo2S",
  server: false

# In test we don't send emails.
config :pickle, Pickle.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
