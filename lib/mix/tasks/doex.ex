defmodule Mix.Tasks.Doex do
  use Mix.Task

  @shortdoc "Prints Digital Ocean API v2 mix client help information"

  @moduledoc"""
  Prints (doex) Digital Ocean API v2 mix client help information

       mix doex

  See `mix help dio.config` to see all available configuration options.
  """

  def run(raw_args) do
    {_opts, args, _} = OptionParser.parse(raw_args)

    case args do
      [] -> general()
      _ -> Mix.shell.error("Invalid arguments, expected: mix dio")
    end
  end

  defp general() do
    Mix.shell.info "doex v" <> Doex.version
    Mix.shell.info "doex is a API client for Digital Ocean's API v2."
    newline()

    Mix.shell.info "Available tasks:"
    newline()
    Mix.Task.run("help", ["--search", "doex."])
    newline()

    Mix.shell.info "Further information can be found here:"
    Mix.shell.info "  -- https://hex.pm/packages/doex"
    Mix.shell.info "  -- https://github.com/capbash/doex"
    newline()
  end

  def newline(), do: Mix.shell.info ""

end
