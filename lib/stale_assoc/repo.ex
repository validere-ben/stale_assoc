defmodule StaleAssoc.Repo do
  use Ecto.Repo,
    otp_app: :stale_assoc,
    adapter: Ecto.Adapters.Postgres
end
