defmodule Doex.Cli.Scp do
  use FnExpr
  alias Doex.Cli.Parser
  alias Doex.Io.Shell

  @moduledoc"""
  Secure copy a file from <src> to your droplet's <target>

       doex scp <droplet_name> <src> <target>

  You can provide the droplet ID, referenece it by name, or by tag (if you add the --tag option)

  For example

      doex scp my_app ./bin/env /src/my_app/bin/env

  If you have a specific config file, `mix help doex.config` then add it as an environment variable

      DOEX_CONFIG=/tmp/my.doex doex scp my_app ./bin/env /src/my_app/bin/env

  """

  @options %{
    tag: :boolean,
  }

  def run(raw_args) do
    Doex.start

    raw_args
    |> Parser.parse(@options)
    |> invoke(fn {opts, [name, src, target]} ->
         name
         |> Doex.Client.find_droplet(opts)
         |> invoke(fn
              nil -> Shell.unknown_droplet(name, ["scp" | raw_args])
              id -> id
            end)
         |> Doex.Client.droplet_ip
         |> scp(src, target)
       end)
    |> Shell.info(raw_args)
  end

  def scp(nil, _src, _target), do: nil
  def scp(ip, src, target) do
    {_, 0} = System.cmd("scp", [src, "root@#{ip}:#{target}"])
    "scp #{src} root@#{ip}:#{target}"
  end

end
