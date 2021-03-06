defmodule Fourchan.Mixfile do
  use Mix.Project

  def project do
    [app: :fourchan,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Fourchan, []},
      applications: [
        :phoenix, :phoenix_html, :cowboy, :logger, :gettext,
        :phoenix, :phoenix_pubsub_redis, :extwitter
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.1"},
      {:phoenix_html, "~> 2.3"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.9"},
      {:cowboy, "~> 1.0"},
      {:floki, "~> 0.7.1"},
      {:httpoison, "~> 0.8"},
      {:phoenix_pubsub_redis, "~> 2.0.0"},
      {:oauth, github: "tim/erlang-oauth"},
      {:extwitter, "~> 0.6"}
    ]
  end
end
