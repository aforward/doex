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

  test "droplet_ip none" do
    %{"id" => 1234, "networks" => %{"v4" => [%{"gateway" => "10.137.0.1", "ip_address" => "99.98.97.96", "netmask" => "255.255.0.0", "type" => "private"}, %{"gateway" => "138.197.160.1", "ip_address" => "199.198.197.196", "netmask" => "255.255.240.0", "type" => "public"}], "v6" => [%{"gateway" => "9999:A880:0CAD:00D0:0000:0000:0000:0001", "ip_address" => "9999:A880:0CAD:00D0:0000:0000:362A:8001", "netmask" => 64, "type" => "public"}]}, "status" => "active"}

    assert nil == Client.droplet_ip(nil)
    assert nil == Client.droplet_ip(%{})
    assert nil == Client.droplet_ip(%{"networks" => %{}})
    assert nil == Client.droplet_ip(%{"networks" => %{"v6" => [%{"type" => "public", "ip_address" => "9999"}]}})
  end

  test "droplet_ip OK" do
    droplet = %{"id" => 1234, "networks" => %{"v4" => [%{"gateway" => "10.137.0.1", "ip_address" => "99.98.97.96", "netmask" => "255.255.0.0", "type" => "private"}, %{"gateway" => "138.197.160.1", "ip_address" => "199.198.197.196", "netmask" => "255.255.240.0", "type" => "public"}], "v6" => [%{"gateway" => "9999:A880:0CAD:00D0:0000:0000:0000:0001", "ip_address" => "9999:A880:0CAD:00D0:0000:0000:362A:8001", "netmask" => 64, "type" => "public"}]}, "status" => "active"}
    assert "199.198.197.196" == Client.droplet_ip(droplet)
  end

end