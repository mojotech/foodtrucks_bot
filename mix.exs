defmodule FoodtruckBot.Mixfile do
  use Mix.Project

  def project do
    [
      app: :foodtruck_bot,
      version: "1.1.0",
      elixir: "~> 1.8",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :slack, :extwitter, :timex], mod: {FoodtruckBot, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:slack, "0.23.5"},
      # {:slack, github: "BlakeWilliams/Elixir-Slack"},
      {:oauth, github: "tim/erlang-oauth"},
      {:extwitter, "~> 0.8.3"},
      {:timex, "~> 3.1.13"}
    ]
  end
end
