defmodule Mix.Tasks.Doex.Put do
  use Mix.Task

  @shortdoc "Execute a Digital Ocean API PUT request."

  @moduledoc """
  Execute a Digital Ocean API PUT request:

      doex put <path> <attributes>

  For example:

      mix doex.put /images/12345 --name newname

  The output will be similar to the following, and it's the IDs you want:

      {:ok,
       %{"image" => %{"created_at" => "2017-08-02T13:54:05Z",
           "distribution" => "Ubuntu", "id" => 12345, "min_disk_size" => 20,
           "name" => "newname", "public" => false,
           "regions" => ["tor1"], "size_gigabytes" => 2.05, "slug" => nil,
           "type" => "snapshot"}}}

  """

  def run(args), do: Doex.Cli.Main.run({:put, args})
end
