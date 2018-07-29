defmodule Mix.Tasks.Doex.Droplets.Tag do
  use Mix.Task
  use FnExpr

  @shortdoc "Tag a droplet."

  @moduledoc """
  Tag a droplet.

       doex droplets.tag <droplet_name_or_id> <tag_name>

  For example

      doex droplets.tag my_app production

  If you have a specific config file, `mix help doex.config` then add it as an environment variable

      DOEX_CONFIG=/tmp/my.doex doex droplets.tag my_app production

  """

  def run(args), do: Doex.Cli.Main.run({:droplets_tag, args})
end
