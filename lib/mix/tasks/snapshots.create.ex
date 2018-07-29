defmodule Mix.Tasks.Doex.Snapshots.Create do
  use Mix.Task
  use FnExpr

  @shortdoc "Creates a snapshot of an existing Digital Ocean droplet"

  @moduledoc """
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

  def run(args), do: Doex.Cli.Main.run({:snapshots_create, args})
end
