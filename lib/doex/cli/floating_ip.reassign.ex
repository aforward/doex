defmodule Doex.Cli.FloatingIp.Reassign do
  use FnExpr

  alias Doex.Cli.Parser
  alias Doex.Io.Shell
  alias Doex.Client

  @moduledoc"""
  Reassign a floating IP from one droplet to another

       doex floating_ip.reassign <old_droplet_name> <new_droplet_name>

  Or, by tag

      doex floating_ip.id <old_droplet_tag> <new_droplet_tag> --tag

  If by tag, it will grab the `latest`

  For example

      doex floating_ip.reassign myapp01 myapp02

  If you have a specific config file, `mix help doex.config` then add it as an environment variable

      DOEX_CONFIG=/tmp/my.doex doex floating_ip.reassign myapp01 myapp02

  """

  @options %{
    tag: :boolean,
  }

  def run(raw_args) do
    Doex.start

    raw_args
    |> Parser.parse(@options)
    |> invoke(fn {opts, [from_name, to_name]} ->
          Client.reassign_floating_ip(from_name, to_name, opts)
       end)
    |> Shell.inspect(raw_args)
  end

end
