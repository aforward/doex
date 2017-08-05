defmodule Doex.Cli.Snapshots.Create do
  use FnExpr
  alias Doex.Cli.{Parser, Shell}

  @moduledoc"""
  Creates a snapshot of an existing Digital Ocean droplet.  This
  differs from the underlying snapshot API, as it will ensure all
  necessary preconditions are set, and can (if desired) block until
  the process is finished

       doex snapshots.create <droplet_id> <snapshot_name>

  The following options with examples are shown below:

      --delete   true/false    If true, delete droplet when finished
      --block    true/false    Regardless of delete, block until finished

  For example

      doex snapshots.create 12345 my_app --delete

  If you have a specific config file, `mix help doex.config` then add it as an environment variable

      DOEX_CONFIG=/tmp/my.doex doex snapshots.create 12345 my_app --delete

  """

  @options %{
    delete: :boolean,
    block: :boolean,
    quiet: :boolean,
  }

  def run(raw_args) do
    raw_args
    |> Parser.parse(@options)
    |> create_snapshot
  end

  defp create_snapshot({opts, [droplet_id, snapshot_name]}) do
    Doex.start

    Shell.info("Powering off droplet #{droplet_id}...", opts)
    Doex.Api.post("/droplets/#{droplet_id}/actions", %{type: "power_off"})
    |> Shell.inspect(opts)
    |> Doex.Cli.Block.block_until
    Shell.info("DONE, Powering off droplet #{droplet_id}.", opts)

    Shell.info("Creating snapshot named #{snapshot_name}...", opts)
    Doex.Api.post("/droplets/#{droplet_id}/actions", %{type: "snapshot", name: snapshot_name})
    |> invoke(fn resp ->
         if opts[:delete] || opts[:block] do
           Doex.Cli.Block.block_until(resp)
           Shell.info("DONE, Creating snapshot named #{snapshot_name}.", opts)
         else
           Shell.info("WORKING, Creating snapshot named #{snapshot_name}.", opts)
         end
       end)

    if opts[:delete] do
      Shell.info("Deleting droplet #{droplet_id}...", opts)
      {:ok, nil} = Doex.Api.delete("/droplets/#{droplet_id}")
    end

    snapshot_name
  end

end