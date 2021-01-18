import Config

config :stale_assoc,
  ecto_repos: [StaleAssoc.Repo],
  generators: [binary_id: true]

config :stale_assoc, StaleAssoc.Repo,
  username: "postgres",
  password: "postgres",
  database: "stale_assoc_dev",
  hostname: "localhost",
  port: 5432
