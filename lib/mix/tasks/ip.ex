defmodule Mix.Tasks.Doex.Ip do
  use Mix.Task
  use FnExpr

  @shortdoc "Get the IP of a droplet"

  @moduledoc"""
  Get the IP of a droplet

       doex ip <droplet_id_or_name_or_tag> <shell_command>?

  For example,

      doex ip my_app "ls -la"

  If you have a specific config file, `mix help doex.config` then add it as an environment variable

      DOEX_CONFIG=/tmp/my.doex doex ip my_app

  This is useful to SSH into your droplet, for example

      ssh root@`doex ip my_app`

  """

  def run(args), do: Doex.Cli.Main.run({:ip, args})

end
