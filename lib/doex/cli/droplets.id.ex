defmodule Doex.Cli.Droplets.Id do
  use FnExpr
  alias Doex.Cli.{Parser, Shell}

  @moduledoc"""
  Locate a droplet ID.  This can be done by name

       doex droplets.id <droplet_name>

  Or, by tag

      doex droplets.id <tag> --tag

  If by tag, it will grab the `latest`

  For example

      doex droplets.id my_app

  If you have a specific config file, `mix help doex.config` then add it as an environment variable

      DOEX_CONFIG=/tmp/my.doex doex droplets.id my_app

  """

  @options %{
    tag: :boolean,
  }

  def run(raw_args) do
    Doex.start

    raw_args
    |> Parser.parse(@options)
    |> invoke(fn {opts, [name]} -> Doex.Client.find_droplet_id(name, opts) end)
    |> Shell.info
  end

end
