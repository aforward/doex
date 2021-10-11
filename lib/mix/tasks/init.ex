defmodule Mix.Tasks.Doex.Init do
  use Mix.Task

  @shortdoc "Initialize your doex config."

  @moduledoc """
  Initialize your doex config:

      mix doex.init

  See `mix help doex.config` to see all available configuration options.
  """
  def run(args), do: Doex.Cli.Main.run({:init, args})
end
