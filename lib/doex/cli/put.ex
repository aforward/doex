defmodule Doex.Cli.Put do
  use FnExpr
  alias Doex.Cli.{Parser, Shell}

  @moduledoc"""
  Execute a Digital Ocean API POST request

       doex put <path> <attributes>

  For example

      doex put /images/12345 --name newname

  The output will be similar to the following, and it's the IDs you want.

      {:ok,
       %{"image" => %{"created_at" => "2017-08-02T13:54:05Z",
           "distribution" => "Ubuntu", "id" => 12345, "min_disk_size" => 20,
           "name" => "newname", "public" => false,
           "regions" => ["tor1"], "size_gigabytes" => 2.05, "slug" => nil,
           "type" => "snapshot"}}}

  """

  def run(raw_args) do
    {:ok, _started} = Application.ensure_all_started(:doex)

    raw_args
    |> Parser.parse()
    |> invoke(fn {body, [endpoint]} -> Doex.Api.put(endpoint, body) end)
    |> Shell.inspect(raw_args)
  end

end
