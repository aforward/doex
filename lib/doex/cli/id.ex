defmodule Doex.Cli.Id do
  use FnExpr
  alias Doex.Cli.Parser
  alias Doex.Io.Shell

  @moduledoc"""
  Locate a ID of a resource.  This can be done by name or tag.

       doex id <--resource_type> <resource_name>

  Or, by tag

      doex droplets.id <--resource_type> <tag> --tag

  If by tag, it will grab the `latest`.

  Currently, the only supported resource type is a `--droplets`, but more are coming.

  For example

      doex id my_app --droplets

  Droplets are also the default, so the `--droplets` can be omitted.

      doex id my_app

  If you have a specific config file, `mix help doex.config` then add it as an environment variable

      DOEX_CONFIG=/tmp/my.doex doex id my_app

  """

  @options %{
    tag: :boolean,
    droplets: :boolean,
    droplet: :boolean,
  }

  def run(raw_args) do
    Doex.start

    raw_args
    |> Parser.parse(@options)
    |> invoke(fn {opts, [name]} -> find_id(name, opts) end)
    |> Shell.info
  end

  def find_id(name, %{droplets: true} = opts), do: Doex.Client.find_droplet_id(name, opts)
  def find_id(name, %{droplet: true} = opts), do: Doex.Client.find_droplet_id(name, opts)
  def find_id(name, opts), do: Doex.Client.find_droplet_id(name, opts)

end
