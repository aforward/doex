defmodule Mix.Tasks.Doex.Config do
  use Mix.Task

  @shortdoc "Reads, updates or deletes Doex config"

  @moduledoc """
  Reads, updates or deletes Doex configuration keys.

      mix doex.config KEY [VALUE]

  Look at available settings and definitions in the
  [Digital Ocean API V2 Documentation](https://www.digitalocean.com/community/tutorials/how-to-use-the-digitalocean-api-v2)

  ## Config keys

    * `token` - Digitial Ocean Token ()
    * `ssh_keys` - The SSH Key "IDs" stored in Digital Ocean to grant to new droplets

  ## Command line options

    * `--delete` - Remove a specific config key
  """

  def run(args), do: Doex.Cli.Main.run({:config, args})

end
