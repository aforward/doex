defmodule Mix.Tasks.Doex.FloatingIp.Id do
  use Mix.Task
  use FnExpr

  @shortdoc "Locate a floating ip ID, by droplet name (or --tag) that it's assigned to."

  @moduledoc """
  Locate a floating ip ID.

  This can be done by name:

      doex floating_ip.id <droplet_name>

  Or, by tag:

      doex floating_ip.id <tag> --tag

  If by tag, it will grab the `latest`

  For example:

      doex floating_ip.id my_app

  If you have a specific config file, `mix help doex.config` then add it as an
  environment variable:

      DOEX_CONFIG=/tmp/my.doex doex floating_ip.id my_app

  """

  def run(args), do: Doex.Cli.Main.run({:floating_ip_id, args})
end
