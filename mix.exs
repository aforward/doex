defmodule Doex.Mixfile do
  use Mix.Project

  @name    :doex
  @version "0.1.0"

  @deps [
    {:mix_test_watch, "~> 0.3", only: :dev, runtime: false},
    {:poison, "~> 3.1.0"},
    {:httpoison, "~> 0.11.1"},
    {:ex_doc, ">= 0.0.0", only: :dev},
  ]

  @aliases [
  ]

  # ------------------------------------------------------------

  def project do
    in_production = Mix.env == :prod
    [
      app:     @name,
      version: @version,
      elixir:  ">= 1.4.5",
      deps:    @deps,
      aliases: @aliases,
      build_embedded:  in_production,
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

end
