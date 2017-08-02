defmodule Doex.Cli.Main do
  use FnExpr
  alias Doex.Cli.Shell

  def main(argv) do
    argv
    |> parse
    |> run
  end

  def run({:doex, _}) do
    Shell.info "doex v" <> Doex.version
    Shell.info "doex is a API client for Digital Ocean's API v2."
    Shell.newline

    Shell.info "Available tasks:"
    Shell.newline
    # Run `mix help --search doex.` to get this output
    # and paste here, replacing `mix doex.` with just `doex `
    Shell.info "#{Shell.cmd("doex block")}           # Block the command line until a condition is met"
    Shell.info "#{Shell.cmd("doex config")}          # Reads, updates or deletes Doex config"
    Shell.info "#{Shell.cmd("doex droplets.create")} # Create a droplet on Digital Ocean"
    Shell.info "#{Shell.cmd("doex get")}             # Execute a Digital Ocean API GET request"
    Shell.info "#{Shell.cmd("doex init")}            # Initialize your doex config"

    Shell.newline

    Shell.info "Further information can be found here:"
    Shell.info "  -- https://hex.pm/packages/doex"
    Shell.info "  -- https://github.com/capbash/doex"
    Shell.newline
  end

  def run({:config, args}), do: Doex.Cli.Config.run(args)
  def run({:droplets_create, args}), do: Doex.Cli.Droplets.Create.run(args)
  def run({:init, args}), do: Doex.Cli.Init.run(args)
  def run({:get, args}), do: Doex.Cli.Get.run(args)
  def run({:block, args}), do: Doex.Cli.Block.run(args)
  def run({unknown_cmd, _args}) do
    Shell.error "Unknown command, #{unknown_cmd}, check spelling and try again"
    Shell.newline
    Shell.newline
    run({:doex, []})
  end

  defp parse([]), do: {:doex, []}
  defp parse([subcommand | subargs]) do
    subcommand
    |> String.replace(".", "_")
    |> String.to_atom
    |> invoke({&1, subargs})
  end

end