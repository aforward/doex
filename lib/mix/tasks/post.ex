defmodule Mix.Tasks.Doex.Post do
  use Mix.Task

  @shortdoc "Execute a Digital Ocean API POST request"

  @moduledoc"""
  Execute a Digital Ocean API POST request

       doex post <path> <attributes>

  For example

      doex post /droplets --name mydroplet --size 512mb --image ubuntu-14-04-x64 --region nyc3 --private-networking

  The output will be similar to the following, and it's the IDs you want.

      {:ok,
       %{"links" => %{}, "meta" => %{"total" => 2},
         "ssh_keys" => [%{"fingerprint" => "18:19:20:21:22:23:24:25:26:27:28:29:30:31:32:33",
            "id" => 555213, "name" => "mbp",
            "public_key" => "ssh-dss ABC123"},
          %{"fingerprint" => "19:20:21:22:23:24:25:26:27:28:29:30:31:32:33:34",
            "id" => 555214, "name" => "andrew13mbp",
            "public_key" => "ssh-rsa DEF456"}]}}

  Note that `private_networking` DO parameter is changed to dash case `private-networking`
  and it's a boolean paramater, so it defaults to true if set)
  """

  def run(args), do: Doex.Cli.Main.run({:post, args})

end
