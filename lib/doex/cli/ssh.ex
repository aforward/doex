defmodule Doex.Cli.Ssh do
  use FnExpr
  alias Doex.Cli.Parser
  alias Doex.Io.Shell

  @moduledoc """
  Execute a command on your droplet

       doex ssh <droplet_id_or_name_or_tag> <cmd>

  You can provide the droplet ID, reference it by name, or by tag (if you add the --tag option)

  For example

      doex ssh my_app "ls -la"

  If you have a specific config file, `mix help doex.config` then add it as an environment variable

      DOEX_CONFIG=/tmp/my.doex doex ssh my_app "ls -la"

  """

  @options %{
    tag: :boolean,
    timeout: :integer
  }

  def run(raw_args) do
    Doex.start()

    raw_args
    |> Parser.parse(@options)
    |> invoke(fn {opts, [name, cmd]} ->
      name
      |> Doex.Client.find_droplet(opts)
      |> invoke(fn
        nil -> Shell.unknown_droplet(name, ["ssh" | raw_args])
        id -> id
      end)
      |> Doex.Client.droplet_ip()
      |> ssh(cmd, opts)
    end)
    |> Shell.info(raw_args)
  end

  def ssh(nil, _cmd, _opts), do: nil

  def ssh(ip, cmd, _opts) do
    # TODO: move System.cmd to Port to allow for timeout
    # @default_timeout 30 # <--- move that back to the top when fixed
    # timeout = opts[:timeout]
    # |> invoke(fn
    #      0 -> @default_timeout
    #      t -> t
    #    end)
    {output, _exit} =
      System.cmd(
        "ssh",
        [
          "-o",
          "TCPKeepAlive=yes",
          "-o",
          "ServerAliveInterval=30",
          "-o",
          "ConnectTimeout=30",
          "-o",
          "BatchMode=yes",
          "root@#{ip}",
          cmd
        ]
      )

    Shell.info(output)
  end
end
