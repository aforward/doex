defmodule Mix.Tasks.Doex.Init do
  use Mix.Task

  @shortdoc "Initialize your doex config"

  def run(args), do: Doex.Cli.Main.run({:init, args})

end
