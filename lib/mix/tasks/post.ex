defmodule Mix.Tasks.Doex.Post do
  use Mix.Task

  @shortdoc "Execute a Digital Ocean API POST request."

  @moduledoc """
  Execute a Digital Ocean API POST request:

      doex post <path> <attributes>

  For example:

      mix doex.post /droplets --name mydroplet --size s-1vcpu-1gb --image ubuntu-18-04-x64 --region nyc3 --private-networking

  The output will be similar to the following, and it's the IDs you want:

      {:ok,
       %{"droplet" => %{"backup_ids" => [], "created_at" => "2017-08-03T13:37:27Z",
           "disk" => 20, "features" => [], "id" => 1234546,
           "image" => %{"created_at" => "2017-08-02T21:20:30Z",
             "distribution" => "Ubuntu", "id" => 26767465, "min_disk_size" => 20,
             "name" => "14.04.5 x64", "public" => true,
             "regions" => ["nyc1", "sfo1", "nyc2", "ams2", "sgp1", "lon1", "nyc3",
              "ams3", "fra1", "tor1", "sfo2", "blr1"], "size_gigabytes" => 0.27,
             "slug" => "ubuntu-18-04-x64", "type" => "snapshot"}, "kernel" => nil,
           "locked" => true, "memory" => 512, "name" => "mydroplet",
           "networks" => %{"v4" => [], "v6" => []}, "next_backup_window" => nil,
           "region" => %{"available" => true,
             "features" => ["private_networking", "backups", "ipv6", "metadata",
              "install_agent"], "name" => "New York 3",
             "sizes" => ["s-1vcpu-1gb", "1gb", "2gb", "c-2", "4gb", "c-4", "8gb", "c-8",
              "16gb", "m-16gb", "c-16", "32gb", "m-32gb", "48gb", "c-32", "m-64gb",
              "64gb", "m-128gb", "m-224gb"], "slug" => "nyc3"},
           "size" => %{"available" => true, "disk" => 20, "memory" => 512,
             "price_hourly" => 0.00744, "price_monthly" => 5.0,
             "regions" => ["ams2", "ams3", "blr1", "fra1", "lon1", "nyc1", "nyc2",
              "nyc3", "sfo1", "sfo2", "sgp1", "tor1"], "slug" => "s-1vcpu-1gb",
             "transfer" => 1.0, "vcpus" => 1}, "size_slug" => "s-1vcpu-1gb",
           "snapshot_ids" => [], "status" => "new", "tags" => [], "vcpus" => 1,
           "volume_ids" => []},
         "links" => %{"actions" => [%{"href" => "https://api.digitalocean.com/v2/actions/5431515",
              "id" => 5431515, "rel" => "create"}]}}}

  Note that `private_networking` DO parameter is changed to dash case
  `private-networking` and it's a boolean parameter, so it defaults to true if
  set)
  """

  def run(args), do: Doex.Cli.Main.run({:post, args})
end
