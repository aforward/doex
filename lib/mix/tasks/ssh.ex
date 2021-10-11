defmodule Mix.Tasks.Doex.Ssh do
  use Mix.Task
  use FnExpr

  @shortdoc "Execute a command on your droplet."

  @moduledoc """
  Execute a command on your droplet:

      doex ssh <droplet_id_or_name_or_tag> <cmd>

  You can provide the droplet ID, reference it by name, or by tag (if you add
  the --tag option).

  For example:

      doex ssh my_app "ls -la"

  If you have a specific config file, `mix help doex.config` then add it as an
  environment variable.

      DOEX_CONFIG=/tmp/my.doex doex ssh my_app "ls -la"

  """

  def run(args), do: Doex.Cli.Main.run({:ssh, args})
end
