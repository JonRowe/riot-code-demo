defmodule Riot.MixProject do
  use Mix.Project

  def project do
    [
      app: :riot,
      version: "0.1.0",
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :httpotion]
    ]
  end

  defp deps do
    [
      {:bypass, "~> 1.0", only: :test},
      {:jason, "~> 1.1"},
      {:httpotion, "~> 3.1"}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
