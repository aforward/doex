defmodule Doex.Cli.FloatingIp.Id do
  use FnExpr

  @moduledoc"""
  Locate a floating ip ID.  This can be done by name

       doex floating_ip.id <droplet_name>

  Or, by tag

      doex floating_ip.id <tag> --tag

  If by tag, it will grab the `latest`

  For example

      doex floating_ip.id my_app

  If you have a specific config file, `mix help doex.config` then add it as an environment variable

      DOEX_CONFIG=/tmp/my.doex doex floating_ip.id my_app

  """

  def run(raw_args), do: Doex.Cli.Id.run(["--floating-ip" | raw_args])

end
