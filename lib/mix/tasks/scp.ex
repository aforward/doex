defmodule Mix.Tasks.Doex.Scp do
  use Mix.Task
  use FnExpr

  @shortdoc "Secure copy a file from <src> to your droplet's <target>."

  @moduledoc """
  Secure copy a file from <src> to your droplet's <target>:

      doex scp <droplet_name> <src> <target>

  You can provide the droplet ID, reference it by name, or by tag (if you add
  the --tag option).

  For example:

      doex scp my_app ./bin/env /src/my_app/bin/env

  If you have a specific config file, `mix help doex.config` then add it as an
  environment variable:

      DOEX_CONFIG=/tmp/my.doex doex scp my_app ./bin/env /src/my_app/bin/env

  """

  def run(args), do: Doex.Cli.Main.run({:scp, args})
end
