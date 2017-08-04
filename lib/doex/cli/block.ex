defmodule Doex.Cli.Block do
  use FnExpr
  alias Doex.Cli.{Parser}

  @moduledoc"""
  Block the command line until a condition is met,

  Currently, we support blocking on action statuses,

        doex block actions <id> <status>

  And, droplet statuses

        doex block droplets <id> <status>

  For example,

        doex block actions 12345 completed
        doex block droplets 5672313 active

  The process is silent, so if you put in an invalid status,
  the script will run until manually stopped.
  """

  def run(raw_args) do
    Doex.start

    raw_args
    |> Parser.parse
    |> block_until
  end

  def block_until({_opts, ["droplets", id, status]} = input) do
    Doex.Api.get("/droplets/#{id}")
    |> invoke(fn {:ok, %{"droplet" => %{"status" => current_status}}} ->
         block_until(current_status, status, input)
       end)
  end

  def block_until({_opts, ["actions", id, status]} = input) do
    Doex.Api.get("/actions/#{id}")
    |> invoke(fn {:ok, %{"action" => %{"status" => current_status}}} ->
         block_until(current_status, status, input)
       end)
  end

  defp block_until(current_status, desired_status, input) do
    if desired_status != current_status do
      :timer.sleep(10000)
      block_until(input)
    end
  end

end
