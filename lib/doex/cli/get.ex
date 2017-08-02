defmodule Doex.Cli.Get do
  use FnExpr
  alias Doex.Cli.{Parser, Shell}

  @moduledoc"""
  Execute a Digital Ocean API GET request

       doex get <path>

  For example

      doex get /account/keys

  """

  def run(raw_args) do
    {:ok, _started} = Application.ensure_all_started(:doex)

    raw_args
    |> Parser.parse
    |> invoke(fn {opts, [endpoint]} -> {opts, Doex.Api.get(endpoint)} end)
    |> Shell.inspect
  end

end
