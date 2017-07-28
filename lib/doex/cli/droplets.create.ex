defmodule Doex.Cli.Droplets.Create do
  use FnExpr
  alias Doex.Cli.Parser

  @moduledoc"""
  Create a new digital ocean droplet

       doex droplets.create <name> <options>

  The following options with examples are shown below:

      --region              nyc3
      --size                512mb
      --image               ubuntu-14-04-x64
      --ssh_keys            1234,5467
      --backups             # add option to enable
      --ipv6                # add option to enable
      --user_data           # TODO figure out what this should be
      --private_networking  # add option to enable
      --volumes             # TODO figure out what this should be
      --tags                web,uat,temp

  For example

      doex droplets.create mydroplet \

        --region tor1 \

        --tags myt \

        --image ubuntu-14-04-x64 \

        --size 512mb

  If you have a specific config file, `mix help doex.config` then add it as an environment variable

      DOEX_CONFIG=/tmp/my.doex doex droplets.create mydroplet \

        --region tor1 \

        --tags myt \

        --image ubuntu-14-04-x64 \

        --size 512mb

  """

  @options %{
    region: :string,
    size: :string,
    image: :string,
    ssh_keys: :list,
    backups: :boolean,
    ipv6: :boolean,
    user_data: :string,
    private_networking: :boolean,
    volumes: :string,
    tags: :list,
  }

  def run(raw_args) do
    Mix.Task.run "app.start", []

    raw_args
    |> Parser.parse(@options)
    |> invoke(fn {opts, [name]} -> opts |> Map.put(:name, name) end)
    |> invoke(Doex.Api.post("/droplets", &1))
    |> IO.inspect
  end

end
