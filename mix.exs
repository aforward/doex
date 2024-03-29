defmodule Doex.Mixfile do
  use Mix.Project

  @app :doex
  @git_url "https://github.com/aforward/doex"
  @home_url @git_url
  @version "0.14.1"

  @deps [
    {:mix_test_watch, "~> 1.0", only: :dev, runtime: false},
    {:jason, "~> 1.1"},
    {:httpoison, "~> 1.6"},
    {:fn_expr, "~> 0.3"},
    {:version_tasks, "~> 0.12"},
    {:ex_doc, ">= 0.0.0", only: :dev}
  ]

  @aliases []

  @package [
    name: @app,
    files: ["lib", "mix.exs", "README*", "LICENSE*"],
    maintainers: ["Andrew Forward"],
    licenses: ["MIT"],
    links: %{"GitHub" => @git_url}
  ]

  @docs [
    extras: [
      "LICENSE.md": [title: "License"],
      "README.md": [title: "Overview"]
    ],
    main: "readme",
    source_url: @git_url,
    source_ref: "v#{@version}",
    formatters: ["html"]
  ]

  @escript [
    main_module: Doex.Cli.Main
  ]

  # ------------------------------------------------------------

  def project do
    in_production = Mix.env() == :prod

    [
      app: @app,
      version: @version,
      elixir: "~> 1.13",
      name: @app,
      description: "A Digital Ocean API v2 client for Elixir (yes, another one)",
      package: @package,
      source_url: @git_url,
      homepage_url: @home_url,
      docs: @docs,
      build_embedded: in_production,
      start_permanent: in_production,
      deps: @deps,
      aliases: @aliases,
      escript: @escript,
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  def application do
    [
      mod: {Doex.Application, []},
      extra_applications: [
        :logger
      ]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_), do: ["lib", "web"]
end
