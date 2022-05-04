defmodule Mix.Tasks.Doex do
  use Mix.Task

  @shortdoc "Prints Digital Ocean API v2 mix client help information."

  @moduledoc """
  Prints (doex) Digital Ocean API v2 mix client help information:

      mix doex

  See `mix help doex.config` to see all available configuration options.
  """

  def run(args), do: Doex.Cli.Main.run({:doex, args})
end
