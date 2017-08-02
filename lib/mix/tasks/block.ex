defmodule Mix.Tasks.Doex.Block do
  use Mix.Task

  @shortdoc "Block the command line until a condition is met"

  @moduledoc"""
  Block the command line until a condition is met.

  For example, block until an action is complete

       doex block actions 1234 complete

  """

  def run(args), do: Doex.Cli.Main.run({:block, args})

end
