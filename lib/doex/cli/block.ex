defmodule Doex.Cli.Block do
  use FnExpr
  alias Doex.Cli.{Parser}

  @moduledoc"""
  Block the command line until a condition is met,

  Currently, we only support blocking on action statuses,

        doex block actions <id> <status>

  For example,

        doex block actions 12345 completed

  The process is silent, so if you put in an invalid status,
  the script will run until manually stopped.
  """

  def run(raw_args) do
    {:ok, _started} = Application.ensure_all_started(:doex)

    raw_args
    |> Parser.parse
    |> block_until
  end

  def block_until({_opts, ["actions", id, status]} = input) do
    {:ok, %{"action" => %{"status" => current_status}}} = Doex.Api.get("/actions/#{id}")
    if status != current_status do
      :timer.sleep(10000)
      block_until(input)
    end
  end

end
