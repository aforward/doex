defmodule Mix.Tasks.Doex.Id do
  use Mix.Task
  use FnExpr

  @shortdoc "Locate a ID of a resource, by name or tag (--tag)"

  @moduledoc"""
  Locate a ID of a resource.  This can be done by name or tag.

       doex id <--resource_type> <resource_name>

  Or, by tag

      doex droplets.id <--resource_type> <tag> --tag

  If by tag, it will grab the `latest`.

  Currently, the only supported resource type is a `--droplets`, but more are coming.

  For example

      doex id my_app --droplets

  Droplets are also the default, so the `--droplets` can be omitted.

      doex id my_app

  If you have a specific config file, `mix help doex.config` then add it as an environment variable

      DOEX_CONFIG=/tmp/my.doex doex id my_app

  """

  def run(args), do: Doex.Cli.Main.run({:id, args})

end
