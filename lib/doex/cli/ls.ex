defmodule Doex.Cli.Ls do
  use FnExpr
  alias Doex.Cli.Parser
  alias Doex.Io.{Shell, Table}

  @moduledoc"""
  List your resources.

       doex ls <--resource_type>

  Currently, the only supported resource type is a `--droplets`, but more are coming.

  For example

      doex ls my_app --droplets

  Droplets are also the default, so the `--droplets` can be omitted.

      doex ls my_app

  If you have a specific config file, `mix help doex.config` then add it as an environment variable

      DOEX_CONFIG=/tmp/my.doex doex ls

  """

  @options %{
    droplets: :boolean,
    droplet: :boolean,
  }

  def run(raw_args) do
    Doex.start

    raw_args
    |> Parser.parse(@options)
    |> invoke(fn {opts, []} -> ls(opts) end)
    |> Enum.map(fn droplet -> [droplet["name"], droplet["id"], droplet["status"]] end)
    |> invoke([["------", "------", "------"] | &1])
    |> invoke([["name", "id", "status"] | &1])
    |> Table.format(padding: 4)
    |> Shell.info
  end

  def ls(%{droplets: true}), do: Doex.Client.list_droplets
  def ls(%{droplet: true}), do: Doex.Client.list_droplets
  def ls(_), do: Doex.Client.list_droplets

end
