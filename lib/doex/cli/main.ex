defmodule Doex.Cli.Main do
  use FnExpr
  alias Doex.Io.Shell

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
    Shell.info "#{Shell.cmd("doex block")}            # Block the command line until a condition is met"
    Shell.info "#{Shell.cmd("doex config")}           # Reads, updates or deletes Doex config"
    Shell.info "#{Shell.cmd("doex delete")}           # Execute a Digital Ocean API DELETE request"
    Shell.info "#{Shell.cmd("doex droplets.create")}  # Create a droplet on Digital Ocean"
    Shell.info "#{Shell.cmd("doex droplets.id")}      # Locate a droplet ID, by name or tag (--tag)"
    Shell.info "#{Shell.cmd("doex droplets.tag")}     # Tag a droplet."
    Shell.info "#{Shell.cmd("doex get")}              # Execute a Digital Ocean API GET request"
    Shell.info "#{Shell.cmd("doex id")}               # Locate a ID of a resource, by name or tag (--tag)"
    Shell.info "#{Shell.cmd("doex init")}             # Initialize your doex config"
    Shell.info "#{Shell.cmd("doex ip")}               # Get the IP of a droplet"
    Shell.info "#{Shell.cmd("doex ls")}               # List your resources."
    Shell.info "#{Shell.cmd("doex post")}             # Execute a Digital Ocean API POST request"
    Shell.info "#{Shell.cmd("doex put")}              # Execute a Digital Ocean API PUT request"
    Shell.info "#{Shell.cmd("doex scp")}             # Secure copy a file from <src> to your droplet's <target>"
    Shell.info "#{Shell.cmd("doex snapshots.create")} # Creates a snapshot of an existing Digital Ocean droplet"
    Shell.info "#{Shell.cmd("doex ssh")}              # Execute a command on your droplet"
    Shell.info "#{Shell.cmd("doex ssh.hostkey")}      # Add the droplet hostkey to the executing server"

    Shell.newline

    Shell.info "Further information can be found here:"
    Shell.info "  -- https://hex.pm/packages/doex"
    Shell.info "  -- https://github.com/capbash/doex"
    Shell.newline
  end

  # TODO: consider moving to macro expansion
  def run({:config, args}), do: Doex.Cli.Config.run(args)
  def run({:id, args}), do: Doex.Cli.Id.run(args)
  def run({:ip, args}), do: Doex.Cli.Ip.run(args)
  def run({:ls, args}), do: Doex.Cli.Ls.run(args)
  def run({:ssh, args}), do: Doex.Cli.Ssh.run(args)
  def run({:ssh_hostkey, args}), do: Doex.Cli.Ssh.Hostkey.run(args)
  def run({:scp, args}), do: Doex.Cli.Scp.run(args)
  def run({:droplets_id, args}), do: Doex.Cli.Droplets.Id.run(args)
  def run({:droplets_tag, args}), do: Doex.Cli.Droplets.Tag.run(args)
  def run({:droplets_create, args}), do: Doex.Cli.Droplets.Create.run(args)
  def run({:snapshots_create, args}), do: Doex.Cli.Snapshots.Create.run(args)
  def run({:init, args}), do: Doex.Cli.Init.run(args)
  def run({:get, args}), do: Doex.Cli.Get.run(args)
  def run({:post, args}), do: Doex.Cli.Post.run(args)
  def run({:put, args}), do: Doex.Cli.Put.run(args)
  def run({:delete, args}), do: Doex.Cli.Delete.run(args)
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