defmodule Mix.Tasks.Doex.Droplets.Id do
  use Mix.Task
  use FnExpr

  @shortdoc "Locate a droplet ID, by name or tag (--tag)."

  @moduledoc """
  Locate a droplet ID.

  This can be done by name:

      doex droplets.id <droplet_name>

  Or, by tag:

      doex droplets.id <tag> --tag

  If by tag, it will grab the `latest`.

  For example:

      doex droplets.id my_app

  If you have a specific config file, `mix help doex.config` then add it as an
  environment variable:

      DOEX_CONFIG=/tmp/my.doex doex droplets.id my_app

  """

  def run(args), do: Doex.Cli.Main.run({:droplets_id, args})
end
