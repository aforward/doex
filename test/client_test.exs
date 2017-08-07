defmodule Doex.ClientTest do
  use ExUnit.Case
  use Doex.LiveCase
  alias Doex.Client

  @tag :live
  test "list_droplets" do
    droplets = Client.list_droplets
    assert length(droplets) > 0
    assert droplets |> List.first |> Map.keys |> Enum.member?("id") == true
  end


end