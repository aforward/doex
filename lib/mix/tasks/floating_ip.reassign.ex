defmodule Mix.Tasks.Doex.FloatingIp.Reassign do
  use Mix.Task
  use FnExpr

  @shortdoc "Reassign a floating IP from one droplet to another"

  @moduledoc"""
  Reassign a floating IP from one droplet to another

       doex floating_ip.reassign <old_droplet_name> <new_droplet_name>

  Or, by tag

      doex floating_ip.id <old_droplet_tag> <new_droplet_tag> --tag

  If by tag, it will grab the `latest`

  For example

      doex floating_ip.reassign myapp01 myapp02

  If you have a specific config file, `mix help doex.config` then add it as an environment variable

      DOEX_CONFIG=/tmp/my.doex doex floating_ip.reassign myapp01 myapp02

  """

  def run(args), do: Doex.Cli.Main.run({:floating_ip_reassign, args})

end
