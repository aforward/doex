defmodule Mix.Tasks.Doex.Imagelets.Create do
  use Mix.Task
  use FnExpr

  @shortdoc "Create a DitigalOcean snapshot based on available templates"

  @default_erlang "19.3-1"
  @default_elixir "1.5.1"
  @default_phoenix "1.3.0"
  @default_postgres "9.6"

  @moduledoc """
  Create a DitigalOcean snapshot based on a select (opinionated) templates

       mix doex.imagelets.create <template> <options>

  The following Digital Ocean options (with examples) are available:

      --region              nyc3
      --size                512mb
      --image               ubuntu-18-04-x64
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

      Erlang    https://packages.erlang-solutions.com/erlang/
      Elixir    https://github.com/elixir-lang/elixir/releases
      Phoenix   https://github.com/phoenixframework/phoenix/releases
      Postgres  http://apt.postgresql.org/pub/repos/apt/dists/xenial-pgdg/

  For example

      doex imagelets.create phoenix \\
        --region tor1 \\
        --tags myt \\
        --image ubuntu-18-04-x64 \\
        --size 512mb \\
        --erlang #{@default_erlang} \\
        --elixir #{@default_elixir} \\
        --phoenix #{@default_phoenix} \\
        --postgres #{@default_postgres}

  """

  def run(args), do: Doex.Cli.Main.run({:imagelets_create, args})
end
