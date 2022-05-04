defmodule Mix.Tasks.Doex.Ssh.Hostkey do
  use Mix.Task
  use FnExpr

  @shortdoc "Add the droplet hostkey to the executing server."

  @moduledoc """
  Add the droplet hostkey to the executing server:

      doex ssh.hostkey <droplet_id_or_name_or_tag>

  You can provide the droplet ID, reference it by name, or by tag (if you add
  the --tag option).

  For example:

      doex ssh.hostkey my_app

  This is useful after you have first created a droplet so that you can then
  SSH into that server without any human intervention asking if you want to
  continue:

      The authenticity of host '99.98.97.97 (99.98.97.97)' can't be established.
      ECDSA key fingerprint is SHA256:ABCDEFHIK/def.
      Are you sure you want to continue connecting (yes/no)?

  If you have a specific config file, `mix help doex.config` then add it as an
  environment variable:

      DOEX_CONFIG=/tmp/my.doex doex ssh.hostkey my_app

  """

  def run(args), do: Doex.Cli.Main.run({:ssh_hostkey, args})
end
