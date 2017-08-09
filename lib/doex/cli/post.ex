defmodule Doex.Cli.Post do
  use FnExpr
  alias Doex.Cli.Parser
  alias Doex.Io.Shell

  @moduledoc"""
  Execute a Digital Ocean API POST request

      doex post <path> <attributes>

  For example

      doex post /droplets --name mydroplet --size 512mb --image ubuntu-16-04-x64 --region nyc3 --private-networking

  The output will be similar to the following, and it's the IDs you want.

      {:ok,
       %{"droplet" => %{"backup_ids" => [], "created_at" => "2017-08-03T13:37:27Z",
           "disk" => 20, "features" => [], "id" => 1234546,
           "image" => %{"created_at" => "2017-08-02T21:20:30Z",
             "distribution" => "Ubuntu", "id" => 26767465, "min_disk_size" => 20,
             "name" => "14.04.5 x64", "public" => true,
             "regions" => ["nyc1", "sfo1", "nyc2", "ams2", "sgp1", "lon1", "nyc3",
              "ams3", "fra1", "tor1", "sfo2", "blr1"], "size_gigabytes" => 0.27,
             "slug" => "ubuntu-16-04-x64", "type" => "snapshot"}, "kernel" => nil,
           "locked" => true, "memory" => 512, "name" => "mydroplet",
           "networks" => %{"v4" => [], "v6" => []}, "next_backup_window" => nil,
           "region" => %{"available" => true,
             "features" => ["private_networking", "backups", "ipv6", "metadata",
              "install_agent"], "name" => "New York 3",
             "sizes" => ["512mb", "1gb", "2gb", "c-2", "4gb", "c-4", "8gb", "c-8",
              "16gb", "m-16gb", "c-16", "32gb", "m-32gb", "48gb", "c-32", "m-64gb",
              "64gb", "m-128gb", "m-224gb"], "slug" => "nyc3"},
           "size" => %{"available" => true, "disk" => 20, "memory" => 512,
             "price_hourly" => 0.00744, "price_monthly" => 5.0,
             "regions" => ["ams2", "ams3", "blr1", "fra1", "lon1", "nyc1", "nyc2",
              "nyc3", "sfo1", "sfo2", "sgp1", "tor1"], "slug" => "512mb",
             "transfer" => 1.0, "vcpus" => 1}, "size_slug" => "512mb",
           "snapshot_ids" => [], "status" => "new", "tags" => [], "vcpus" => 1,
           "volume_ids" => []},
         "links" => %{"actions" => [%{"href" => "https://api.digitalocean.com/v2/actions/5431515",
              "id" => 5431515, "rel" => "create"}]}}}

  Note that `private_networking` DO parameter is changed to dash case `private-networking`
  and it's a boolean paramater, so it defaults to true if set)
  """

  def run(raw_args) do
    Doex.start

    raw_args
    |> Parser.parse()
    |> invoke(fn {body, [endpoint]} -> Doex.Api.post(endpoint, body) end)
    |> Shell.inspect(raw_args)
  end

end
