defmodule StaleAssoc.Application do
  use Application

  def start(_type, _args) do
    children = [
      StaleAssoc.Repo
    ]

    opts = [
      strategy: :one_for_one,
      name: StaleAssoc.Supervisor
    ]

    Supervisor.start_link(children, opts)
  end
end
