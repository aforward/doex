defmodule Mix.Tasks.Doex.Delete do
  use Mix.Task

  @shortdoc "Execute a Digital Ocean API DELETE request."

  @moduledoc """
  Execute a Digital Ocean API DELETE request:

      mix doex.delete <path> <attributes>

  For example:

      mix doex.delete /droplets/123456

  The output will be similar to the following, and it's the IDs you want:

      {:ok, nil}

  """

  def run(args), do: Doex.Cli.Main.run({:delete, args})
end
