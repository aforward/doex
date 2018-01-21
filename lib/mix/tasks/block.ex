defmodule Mix.Tasks.Doex.Block do
  use Mix.Task

  @shortdoc "Block the command line until a condition is met"

  @moduledoc"""
  Block the command line until a condition is met,

  Currently, we support blocking on action statuses,

        doex block actions <id> <status>

  And, droplet statuses

        doex block droplets <droplet_id_or_name_or_tag> <status>

  For example,

        doex block actions 12345 completed
        doex block droplets 5672313 active

  The process is silent, so if you put in an invalid status,
  the script will run until manually stopped.
  """

  def run(args), do: Doex.Cli.Main.run({:block, args})

end
