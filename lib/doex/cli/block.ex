defmodule Doex.Cli.Block do
  use FnExpr
  alias Doex.Cli.{Parser}

  @moduledoc """
  Block the command line until a condition is met,

  Currently, we support blocking on action statuses,

        doex block actions <id> <status>

  And, droplet statuses

        doex block droplets <droplet_id_or_name_or_tag> <status>

  For example,

        doex block actions 12345 completed
        doex block droplets 5672313 active

  The process is silent, so if you put in an invalid status,
  the script will run until manually stopped.
  """

  def run(raw_args) do
    Doex.start()

    raw_args
    |> Parser.parse()
    |> block_until
  end

  def block_until({:ok, %{"action" => %{"id" => id}}}, opts) do
    block_until({opts, ["actions", id, "completed"]})
  end

  def block_until({:ok, %{"droplet" => %{"id" => id}}}, opts) do
    block_until({opts, ["droplets", id, "active"]})
  end

  def block_until({:ok, %{"droplets" => [%{"id" => id} | t]}}, opts) do
    block_until({opts, ["droplets", id, "active"]})
  end

  def block_until({:error, _, _} = reply, _opts) do
    reply
  end

  def block_until({opts, ["droplets", name, status]} = input) do
    name
    |> Doex.Client.find_droplet_id(opts)
    |> invoke(Doex.Api.get("/droplets/#{&1}"))
    |> invoke(fn {:ok, %{"droplet" => %{"status" => current_status}}} ->
      block_until(current_status, status, input, opts)
    end)
  end

  def block_until({opts, ["actions", id, status]} = input) do
    Doex.Api.get("/actions/#{id}")
    |> invoke(fn {:ok, %{"action" => %{"status" => current_status}}} ->
      block_until(current_status, status, input, opts)
    end)
  end

  defp block_until(current_status, desired_status, input, opts) do
    if desired_status != current_status do
      sleep(10)
      block_until(input)
    end

    sleep(opts[:sleep])
  end

  defp sleep(nil), do: nil
  defp sleep(as_str) when is_binary(as_str), do: as_str |> Integer.parse() |> sleep
  defp sleep(in_seconds) when is_integer(in_seconds), do: :timer.sleep(in_seconds * 1000)
  defp sleep({num, _}), do: sleep(num)
end
