defmodule Doex.Cli.Droplets.Id do
  use FnExpr

  @moduledoc """
  Locate a droplet ID.  This can be done by name

       doex droplets.id <droplet_name>

  Or, by tag

      doex droplets.id <tag> --tag

  If by tag, it will grab the `latest`

  For example

      doex droplets.id my_app

  If you have a specific config file, `mix help doex.config` then add it as an environment variable

      DOEX_CONFIG=/tmp/my.doex doex droplets.id my_app

  There is also a more generic task that you can use to locate any resource

      doex id my_app --droplets

  """

  def run(raw_args), do: Doex.Cli.Id.run(["--droplets" | raw_args])
end
