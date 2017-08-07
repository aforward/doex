defmodule Doex.Client do
  use FnExpr

  @moduledoc"""
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
    |> Doex.Api.get
    |> invoke(fn {:ok, %{"droplets" => droplets}} -> droplets end)
    |> List.first
  end

  def find_droplet(name, _opts) do
    "/droplets?page=1&per_page=1000"
    |> Doex.Api.get
    |> invoke(fn {:ok, %{"droplets" => droplets}} -> droplets end)
    |> Enum.filter(fn %{"name" => some_name} -> name == some_name end)
    |> List.first
  end

  def find_droplet_id(name_or_id, opts) do
    name_or_id
    |> Integer.parse
    |> invoke(fn input ->
         case input do
           :error -> name_or_id
                     |> Doex.Client.find_droplet(opts)
                     |> FnExpr.default(%{"id" => name_or_id})
                     |> Map.get("id")
           {id, _} -> id
         end
       end)
  end

  def droplet_ip(nil), do: nil
  def droplet_ip(info) do
    info
    |> get_in(["networks", "v4"])
    |> FnExpr.default([])
    |> Enum.filter(&(&1["type"] == "public"))
    |> List.first
    |> FnExpr.default(%{})
    |> Map.get("ip_address")
  end

  def list_droplets do
    "/droplets?page=1&per_page=1000"
    |> Doex.Api.get
    |> invoke(fn {:ok, %{"droplets" => droplets}} -> droplets end)
  end

end


