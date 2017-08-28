defmodule Doex.Cli.Imagelets.Create do
  use FnExpr
  alias Doex.Cli.Parser
  alias Doex.Io.Shell

  @default_erlang "19.3-1"
  @default_elixir "1.5.1"
  @default_phoenix "1.3.0"
  @default_postgres "9.6"

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
      phoenix               Creates an elixir/phoenix ready application server

  The templates above support additional flags including

      --erlang              #{@default_erlang}
      --elixir              #{@default_elixir}
      --phoenix             #{@default_phoenix}
      --postgres            #{@default_postgres}

  Additional `doex` options that can be used

      --quiet               If set, keep output to a minimum

  Release information (and available version numbers) is available at

      Erlang    https://packages.erlang-solutions.com/erlang
      Elixir    https://github.com/elixir-lang/elixir/releases
      Phoenix   https://github.com/phoenixframework/phoenix/releases
      Postgres  http://apt.postgresql.org/pub/repos/apt/dists/xenial-pgdg/

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
    |> id("elixir", opts, raw_args)
    |> ssh(
         [
            "bash <(curl -s https://raw.githubusercontent.com/capbash/bits/master/bits-installer)",
            "ERLANG_VERSION=#{erlang_version} ELIXIR_VERSION=#{elixir_version} bits install-if elixir",
         ],
         other_opts
       )
    |> snapshot(droplet_name, other_opts)
  end

  defp create_imagelet(["phoenix" | raw_args]) do
    {opts, _} = raw_args |> Parser.parse
    other_opts = if opts[:quiet], do: ["--quiet"], else: []

    erlang_version = opts[:erlang] || @default_erlang
    elixir_version = opts[:elixir] || @default_elixir
    phoenix_version = opts[:phoenix] || @default_phoenix
    postgres_version = opts[:postgres] || @default_postgres

    droplet_name = "erlang#{erlang_version}elixir#{elixir_version}phoenix#{phoenix_version}postgres#{postgres_version}" |> String.replace(~r{[-.]}, "")

    Doex.Cli.Droplets.Create.run([droplet_name, "--block", "--sleep", "10" | raw_args])

    Shell.info("damnit ERLANG_VERSION=#{erlang_version} ELIXIR_VERSION=#{elixir_version} PHOENIX_VERSION=#{phoenix_version} POSTGRES_VERSION=#{postgres_version} bits install-if phoenix")

    droplet_name
    |> id("phoenix", opts, raw_args)
    |> ssh(
         [
            "bash <(curl -s https://raw.githubusercontent.com/capbash/bits/master/bits-installer)",
            "ERLANG_VERSION=#{erlang_version} ELIXIR_VERSION=#{elixir_version} PHOENIX_VERSION=#{phoenix_version} POSTGRES_VERSION=#{postgres_version} bits install-if phoenix",
         ],
         other_opts
       )
    |> snapshot(droplet_name, other_opts)
  end

  defp ssh(nil, _cmds, _opts), do: nil
  defp ssh(id, cmds, opts) do
    Doex.Cli.Ssh.Hostkey.run([id | opts])
    Enum.each(cmds, fn cmd ->
      Shell.info("-----------------")
      Shell.info(cmd)
      Shell.info("-----------------")
      Doex.Cli.Ssh.run([id, cmd, "--timeout", "1200" | opts])
      Shell.info("-----------------")
    end)
    id
  end

  def id(name, template, opts, raw_args) do
    name
    |> Doex.Client.find_droplet_id(opts)
    |> invoke(fn
         nil -> Shell.unknown_droplet(name, ["imagelets.create", template | raw_args])
         id -> id
       end)
  end

  def snapshot(nil, _name, _other_opts), do: nil
  def snapshot(id, name, other_opts) do
    Doex.Cli.Snapshots.Create.run([id, name, "--block", "--delete" | other_opts])
    id
  end

end
