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

  The supported resources include

        --droplets       # Locate a droplet's ID
        --snapshots      # Locate a private image's ID (aka snapshot ID)
        --floating-ips   # Locate a floating ip ID (aka snapshot ID)

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
    snapshots: :boolean,
    snapshot: :boolean,
    floating_ips: :boolean,
    floating_ip: :boolean,
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
  def find_id(name, %{snapshots: true} = opts), do: Doex.Client.find_snapshot_id(name, opts)
  def find_id(name, %{snapshot: true} = opts), do: Doex.Client.find_snapshot_id(name, opts)
  def find_id(name, %{floating_ips: true} = opts), do: Doex.Client.find_floating_ip_id(name, opts)
  def find_id(name, %{floating_ip: true} = opts), do: Doex.Client.find_floating_ip_id(name, opts)
  def find_id(name, opts), do: Doex.Client.find_droplet_id(name, opts)

end
