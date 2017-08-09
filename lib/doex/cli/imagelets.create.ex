defmodule Doex.Cli.Imagelets.Create do
  use FnExpr
  alias Doex.Cli.Parser
  alias Doex.Io.Shell

  @default_erlang "19.3-1"
  @default_elixir "1.5.1"

  @moduledoc"""
  Create a DitigalOcean snapshot based on a select (opinionated) templates

       doex imagelets.create <template> <options>

  The following Digital Ocean options (with examples) are available:

      --region              nyc3
      --size                512mb
      --image               ubuntu-16-04-x64
      --ssh_keys            1234,5467
      --backups             # add option to enable
      --ipv6                # add option to enable
      --private_networking  # add option to enable
      --tags                web,uat,temp

  Please refer to `doex droplets.create` for more details on the creation options.

  These are highly opinionated views of server setup.  If they
  do not align with your opinions then you have two courses of actions;
  a) ignore these tasks, or b) suggest updates.

  We support the following templates.

      elixir                Creates a (relatively) barebones elixir server

  The templates above support additional flags including

      --erlang              #{@default_erlang}
      --elixir              #{@default_elixir}

  Additional `doex` options that can be used

      --quiet               If set, keep output to a minimum

  For example

      doex imagelets.create phoenix \

        --region tor1 \

        --tags myt \

        --image ubuntu-16-04-x64 \

        --size 512mb \

        --erlang #{@default_erlang} \

        --elixir #{@default_elixir} \

        --phoenix #{@default_phoenix} \

        --postgres #{@default_postgres}


  """

  def run(raw_args) do
    Doex.start
    create_imagelet(raw_args)
  end

  defp create_imagelet(["elixir" | raw_args]) do
    {opts, _} = raw_args |> Parser.parse
    other_opts = if opts[:quiet], do: ["--quiet"], else: []

    erlang_version = opts[:erlang] || @default_erlang
    elixir_version = opts[:elixir] || @default_elixir

    droplet_name = "erlang#{erlang_version}elixir#{elixir_version}" |> String.replace(~r{[-.]}, "")

    Doex.Cli.Droplets.Create.run([droplet_name, "--block", "--sleep", "10" | raw_args])

    droplet_name
    |> Doex.Client.find_droplet_id(opts)
    |> invoke(fn
         nil -> Shell.unknown_droplet(droplet_name, ["imagelets.create", "elixir" | raw_args])
         id -> id
       end)
    |> ssh(
         [
            "bash <(curl -s https://raw.githubusercontent.com/capbash/bits/master/bits-installer)",
            "ERLANG_VERSION=#{erlang_version} ELIXIR_VERSION=#{elixir_version} bits install-if elixir",
         ],
         other_opts
       )
    |> invoke(fn
         nil -> nil
         id -> Doex.Cli.Snapshots.Create.run([id, droplet_name, "--block", "--delete" | other_opts])
       end)
  end

  defp ssh(nil, _cmds, _opts), do: nil
  defp ssh(id, cmds, opts) do
    Doex.Cli.Ssh.Hostkey.run([id | opts])
    Enum.each(cmds, fn cmd -> Doex.Cli.Ssh.run([id, cmd, "--timeout", "1200000" | opts]) end)
    id
  end

end
