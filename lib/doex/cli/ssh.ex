defmodule Doex.Cli.Ssh do
  use FnExpr
  alias Doex.Cli.Parser
  alias Doex.Io.Shell

  @moduledoc"""
  Execute a command on your droplet

       doex ssh <droplet_id_or_name_or_tag> <cmd>

  You can provide the droplet ID, referenece it by name, or by tag (if you add the --tag option)

  For example

      doex ssh my_app "ls -la"

  If you have a specific config file, `mix help doex.config` then add it as an environment variable

      DOEX_CONFIG=/tmp/my.doex doex ssh my_app "ls -la"

  """

  @options %{
    tag: :boolean,
  }

  def run(raw_args) do
    Doex.start

    raw_args
    |> Parser.parse(@options)
    |> invoke(fn {opts, [name, cmd]} ->
         name
         |> Doex.Client.find_droplet(opts)
         |> Doex.Client.droplet_ip
         |> ssh(cmd)
       end)
    |> Shell.info(raw_args)
  end

  def ssh(nil, _cmd), do: "Unable to locate droplet, aborting"
  def ssh(ip, cmd) do
    SSHEx.connect(ip: ip, user: "root")
    |> invoke(fn {:ok, conn} -> SSHEx.cmd!(conn, cmd) end)
  end

end
