defmodule Doex.Mixfile do
  use Mix.Project

  @app :doex
  @git_url "https://github.com/capbash/doex"
  @home_url @git_url
  @version "0.4.12"

  @deps [
    {:mix_test_watch, "~> 0.3", only: :dev, runtime: false},
    {:poison, "~> 3.1.0"},
    {:httpoison, "~> 0.11.1"},
    {:fn_expr, "~> 0.1.0"},
    {:version_tasks, "~> 0.9.1"},
    {:sshex, "~> 2.2.0"},
    {:ex_doc, ">= 0.0.0", only: :dev},
  ]

  @aliases [
  ]

  @package [
    name: @app,
    files: ["lib", "mix.exs", "README*", "LICENSE*"],
    maintainers: ["Andrew Forward"],
    licenses: ["MIT"],
    links: %{"GitHub" => @git_url}
  ]

  @escript [
    main_module: Doex.Cli.Main
  ]

  # ------------------------------------------------------------

  def project do
    in_production = Mix.env == :prod
    [
      app:     @app,
      version: @version,
      elixir:  "~> 1.4",
      name: @app,
      description: "A Digital Ocean API v2 client for Elixir (yes, another one)",
      package: @package,
      source_url: @git_url,
      homepage_url: @home_url,
      docs: [main: "Doex",
             extras: ["README.md"]],
      build_embedded:  in_production,
      start_permanent:  in_production,
      deps:    @deps,
      aliases: @aliases,
      escript: @escript,
      elixirc_paths: elixirc_paths(Mix.env),
    ]
  end

  def application do
    [
      mod: { Doex.Application, [] },
      extra_applications: [
        :logger
      ],
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

end
