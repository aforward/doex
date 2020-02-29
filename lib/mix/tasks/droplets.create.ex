defmodule Mix.Tasks.Doex.Droplets.Create do
  use Mix.Task
  use FnExpr

  @shortdoc "Create a droplet on Digital Ocean"

  @moduledoc """
  Create a new digital ocean droplet

       mix doex.droplets.create <name> <options>

  The following options with examples are shown below:

      --region              nyc3
      --size                s-1vcpu-1gb
      --image               ubuntu-18-04-x64
      --ssh_keys            1234,5467
      --backups             # add option to enable
      --ipv6                # add option to enable
      --user_data           # TODO figure out what this should be
      --private_networking  # add option to enable
      --volumes             # TODO figure out what this should be
      --tags                web,uat,temp

  For example

      mix doex.droplets.create mydroplet \\
        --region tor1 \\
        --tags myt \\
        --image ubuntu-18-04-x64 \\
        --size s-1vcpu-1gb

  If you have a specific config file, `mix help doex.config` then add it as an environment variable

      DOEX_CONFIG=/tmp/my.doex mix doex.droplets.create mydroplet \
        --region tor1 \\
        --tags myt \\
        --image ubuntu-18-04-x64 \\
        --size s-1vcpu-1gb

  """

  def run(args), do: Doex.Cli.Main.run({:droplets_create, args})
end
