defmodule Doex.Client do
  use FnExpr
  alias Doex.Io.Shell

  @moduledoc """
  Access service functionality through Elixir functions,
  wrapping the underlying HTTP API calls.

  This is where custom code will be created to
  provide convenience methods.

  Most calls will simply help provide more informed
  defaults, as well as possibly reformat the output
  for easier user.

  As there are no client specific calls yet, you should
  look more at direct calls through the API.

      Doex.Api.call/2
      Doex.Api.get/2
      Doex.Api.post/3
  """

  def find_droplet(tag, %{tag: true}) do
    "/droplets?tag_name=#{tag}"
    |> Doex.Api.get()
    |> analyze_result(%{"droplets" => []})
    |> case do
      %{"droplets" => droplets} -> droplets
    end
    |> List.first()
  end

  def find_droplet(name, _opts) do
    case parse(name) do
      :error ->
        "/droplets?page=1&per_page=1000"
        |> Doex.Api.get()
        |> analyze_result(%{"droplets" => []})
        |> case do
          %{"droplets" => droplets} -> droplets
        end
        |> Enum.filter(fn %{"name" => some_name} -> name == some_name end)
        |> List.first()

      {id, ""} ->
        "/droplets/#{id}"
        |> Doex.Api.get()
        |> analyze_result(%{"droplets" => nil})
        |> case do
          %{"droplet" => droplet} -> droplet
        end
    end
  end

  def find_droplet_id(name_or_id, opts) do
    name_or_id
    |> find_droplet(opts)
    |> FnExpr.default(%{"id" => nil})
    |> Map.get("id")
  end

  def find_snapshot_id(name, _opts \\ %{}) do
    case parse(name) do
      :error ->
        "/snapshots?page=1&per_page=1000"
        |> Doex.Api.get()
        |> analyze_result(%{"snapshots" => []})
        |> case do
          %{"snapshots" => snapshots} -> snapshots
        end
        |> Enum.filter(fn %{"name" => some_name} -> name == some_name end)
        |> List.first()
        |> FnExpr.default(%{"id" => nil})
        |> Map.get("id")

      {id, ""} ->
        id
    end
  end

  def find_floating_ip_id(name_or_id, opts \\ %{}) do
    droplet_id = find_droplet_id(name_or_id, opts)

    "/floating_ips?page=1&per_page=1000"
    |> Doex.Api.get()
    |> analyze_result(%{"floating_ips" => []})
    |> case do
      %{"floating_ips" => floating_ips} -> floating_ips
    end
    |> Enum.filter(fn
      %{"droplet" => %{"id" => ^droplet_id}} -> true
      _ -> false
    end)
    |> List.first()
    |> FnExpr.default(%{"ip" => nil})
    |> Map.get("ip")
  end

  def reassign_floating_ip(from_name, to_name, opts \\ %{}) do
    from_floating_id = find_floating_ip_id(from_name, opts)
    assign_floating_ip(from_floating_id, to_name, opts)
  end

  def assign_floating_ip(from_floating_id, to_name, opts \\ %{}) do
    to_droplet_id = find_droplet_id(to_name, opts)

    "/floating_ips/#{from_floating_id}/actions"
    |> Doex.Api.post(%{type: "assign", droplet_id: to_droplet_id})
  end

  def droplet_ip(nil), do: nil

  def droplet_ip(info) do
    info
    |> get_in(["networks", "v4"])
    |> FnExpr.default([])
    |> Enum.filter(&(&1["type"] == "public"))
    |> List.first()
    |> FnExpr.default(%{})
    |> Map.get("ip_address")
  end

  def list_droplets do
    "/droplets?page=1&per_page=1000"
    |> Doex.Api.get()
    |> analyze_result(%{"droplets" => []})
    |> case do
      %{"droplets" => droplets} -> droplets
    end
  end

  defp parse(int) when is_integer(int), do: {int, ""}
  defp parse(str), do: Integer.parse(str)

  defp analyze_result({:ok, data}, _), do: data

  defp analyze_result({:error, message, details}, default_data) do
    Shell.info("Call failed due to #{message} (#{details})\n")
    default_data
  end
end
