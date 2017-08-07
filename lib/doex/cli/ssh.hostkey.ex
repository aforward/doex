defmodule Doex.Cli.Ssh.Hostkey do
  use FnExpr
  alias Doex.Cli.Parser
  alias Doex.Io.Shell

  @moduledoc"""
  Add the droplet hostkey to the executing server

       doex ssh.hostkey <droplet_id_or_name_or_tag>

  You can provide the droplet ID, referenece it by name, or by tag (if you add the --tag option)

  For example

      doex ssh.hostkey my_app

  This is useful after you have first created a droplet so that you can then SSH into
  that server without any human intervention asking if you want to continue.

      The authenticity of host '99.98.97.97 (99.98.97.97)' can't be established.
      ECDSA key fingerprint is SHA256:ABCDEFHIK/def.
      Are you sure you want to continue connecting (yes/no)?

  If you have a specific config file, `mix help doex.config` then add it as an environment variable

      DOEX_CONFIG=/tmp/my.doex doex ssh.hostkey my_app

  """

  @options %{
    tag: :boolean,
  }

  def run(raw_args) do
    Doex.start

    raw_args
    |> Parser.parse(@options)
    |> invoke(fn {opts, [name]} ->
         name
         |> Doex.Client.find_droplet(opts)
         |> Doex.Client.droplet_ip
         |> ssh_hostkey
       end)
    |> Shell.info(raw_args)
  end

  def ssh_hostkey(nil), do: "Unable to locate droplet, aborting"
  def ssh_hostkey(ip) do
    {_, 0} = System.cmd("ssh", ["-o", "StrictHostKeyChecking no", "root@#{ip}", "uname -a"])
    "Added hostkey for droplet #{ip}"
  end

end
