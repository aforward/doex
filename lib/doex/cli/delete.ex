defmodule Doex.Cli.Delete do
  use FnExpr
  alias Doex.Cli.Parser
  alias Doex.Io.Shell

  @moduledoc """
  Execute a Digital Ocean API DELETE request

       doex delete <path> <attributes>

  For example

      doex delete /droplets/12345

  The output will be similar to the following, and it's the IDs you want.

      {:ok, nil}

  """

  def run(raw_args) do
    Doex.start()

    raw_args
    |> Parser.parse()
    |> invoke(fn {body, [endpoint]} -> Doex.Api.delete(endpoint, body) end)
    |> Shell.inspect(raw_args)
  end
end
