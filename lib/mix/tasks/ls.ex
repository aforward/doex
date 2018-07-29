defmodule Mix.Tasks.Doex.Ls do
  use Mix.Task
  use FnExpr

  @shortdoc "List your resources."

  @moduledoc """
  List your resources.

       doex ls <--resource_type>

  Currently, the only supported resource type is a `--droplets`, but more are coming.

  For example

      doex ls my_app --droplets

  Droplets are also the default, so the `--droplets` can be omitted.

      doex ls my_app

  If you have a specific config file, `mix help doex.config` then add it as an environment variable

      DOEX_CONFIG=/tmp/my.doex doex ls

  """

  def run(args), do: Doex.Cli.Main.run({:ls, args})
end
