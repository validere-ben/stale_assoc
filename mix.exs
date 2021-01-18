defmodule StaleAssoc.MixProject do
  use Mix.Project

  def project do
    [
      app: :stale_assoc,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {StaleAssoc.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ecto_sql, "~> 3.5"},
      {:postgrex, "~> 0.15"}
    ]
  end
end
