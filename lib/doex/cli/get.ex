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
    |> Parser.parse()
    |> invoke(fn {opts, [endpoint]} ->
         opts
         |> Enum.map(fn {k,v} -> "#{k}=#{v}" end)
         |> Enum.join("&")
         |> invoke("#{endpoint}?#{&1}")
         |> String.replace(~r{\?$},"")
       end)
    |> Doex.Api.get
    |> Shell.inspect(raw_args)
  end

end
