defmodule Doex.Cli.Get do
  use FnExpr
  alias Doex.Cli.Parser
  alias Doex.Io.Shell

  @moduledoc"""
  Execute a Digital Ocean API GET request

      doex get <path>

  For example

      doex get /account/keys

  The output will be similar to the following, and it's the IDs you want.

      {:ok,
       %{"links" => %{}, "meta" => %{"total" => 2},
         "ssh_keys" => [%{"fingerprint" => "18:19:20:21:22:23:24:25:26:27:28:29:30:31:32:33",
            "id" => 555213, "name" => "mbp",
            "public_key" => "ssh-dss ABC123"},
          %{"fingerprint" => "19:20:21:22:23:24:25:26:27:28:29:30:31:32:33:34",
            "id" => 555214, "name" => "andrew13mbp",
            "public_key" => "ssh-rsa DEF456"}]}}

  Query parameters are added as options, for example

      doex get /images --page 1 --per-page 1 --private

  Note that `per_page` DO parameter is changed to dash case `per-page`
  and boolean parameters, for example `private`, if present are
  defaulted to be `true` (to force false, use `--<param> false`)
  """

  def run(raw_args) do
    Doex.start

    raw_args
    |> Parser.parse()
    |> invoke(fn {opts, [endpoint]} ->
         opts
         |> Enum.map(fn {k,v} -> "#{k}=#{v}" end)
         |> Enum.join("&")
         |> invoke("#{endpoint}?#{&1}")
         |> String.replace(~r{\?$},"")
       end)
    |> Doex.Api.get
    |> Shell.inspect(raw_args)
  end

end
