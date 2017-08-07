defmodule Doex.Cli.Droplets.Tag do
  use FnExpr
  alias Doex.Cli.Parser
  alias Doex.Io.Shell

  @moduledoc"""
  THIS IS CURRENTLY UNDER CONSTRUCTION, AWAITING FEEDBACK FROM DigitalOcean
  on a possible bug in the resource tag API.

  Tag (or delete a tag on) a droplet.

       doex droplets.tag <droplet_name_or_id> <tag_name>

  To delete the tag, add the `--delete` flag

  For example

      doex droplets.tag my_app production

  Or to remove a tag,

      doex droplets.tag my_app stage --delete

  If you have a specific config file, `mix help doex.config` then add it as an environment variable

      DOEX_CONFIG=/tmp/my.doex doex droplets.tag my_app production

  """

  @options %{
    delete: :boolean,
    tag: :boolean,
  }

  def run(raw_args) do
    Doex.start
    raw_args
    |> Parser.parse(@options)
    |> tag_droplet
    |> Shell.inspect(raw_args)
  end

  defp tag_droplet({opts, [name_or_id, tag_name]}) do
    name_or_id
    |> Doex.Client.find_droplet_id(opts)
    |> invoke(
         Doex.Api.post(
           "/tags/#{tag_name}/resources",
           %{resources: [%{resource_type: "droplet", resource_id: &1}]}))
  end

end
