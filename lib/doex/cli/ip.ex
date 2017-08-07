defmodule Doex.Cli.Ip do
  use FnExpr
  alias Doex.Cli.Parser
  alias Doex.Io.Shell

  @moduledoc"""
  Get the IP of a droplet

       doex ip <droplet_id_or_name_or_tag>

  For example,

      doex ip my_app

  If you have a specific config file, `mix help doex.config` then add it as an environment variable

      DOEX_CONFIG=/tmp/my.doex doex ip my_app

  This is useful to SSH into your droplet, for example

      ssh root@`doex ip my_app`

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
       end)
    |> Shell.info(raw_args)
  end

end
