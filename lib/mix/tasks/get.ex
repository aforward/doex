defmodule Mix.Tasks.Doex.Get do
  use Mix.Task

  @shortdoc "Execute a Digital Ocean API GET request"

  @moduledoc"""
  Execute a Digital Ocean API GET request

       doex get <path>

  For example

      doex get /account/keys

  """

  def run(args), do: Doex.Cli.Main.run({:get, args})

end
