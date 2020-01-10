defmodule Doex.Cli.Config do
  use Mix.Task
  alias Doex.Io.Shell

  @moduledoc """
  Reads, updates or deletes Doex configuration keys.

      doex config KEY [VALUE]

  Look at available settings and definitions in the
  [Digital Ocean API V2 Documentation](https://www.digitalocean.com/community/tutorials/how-to-use-the-digitalocean-api-v2)

  ## Config keys

    * `token` - Digitial Ocean Token ()
    * `ssh_keys` - The SSH Key "IDs" stored in Digital Ocean to grant to new droplets

  ## Command line options

    * `--delete` - Remove a specific config key
  """

  @switches [delete: :boolean]

  def run(args) do
    {opts, args, _} = OptionParser.parse(args, switches: @switches)

    case args do
      [] ->
        list()

      ["$" <> _key | _] ->
        Mix.raise("Invalid key name")

      [key] ->
        if opts[:delete] do
          delete(key)
        else
          read(key)
        end

      [key, value] ->
        set(key, value)

      [key | values] ->
        set(key, values)

      _ ->
        Shell.raise("""
        Invalid arguments, expected:
        #{Shell.cmd("doex config KEY [VALUE]")}
        """)
    end
  end

  defp list() do
    Shell.info("See your configurations below:")
    Shell.info("#{Doex.Config.filename()}\n")

    Enum.each(Doex.Config.read(), fn {key, value} ->
      Shell.info("  #{key}: #{inspect(value, pretty: true)}")
    end)

    Shell.info("\nTo change a config value, run (for example):")
    Shell.info("  doex config token abc123\n")
  end

  defp read(key) do
    key
    |> String.to_atom()
    |> Doex.Config.get()
    |> print(key)
  end

  defp print(nil, key) do
    Mix.raise("Config does not contain any value for #{key}")
  end

  defp print(values, key) when is_list(values) do
    values
    |> Enum.join(",")
    |> print(key)
  end

  defp print(value, _key) do
    Shell.info(value)
  end

  defp delete(key) do
    key
    |> String.to_atom()
    |> Doex.Config.remove()
  end

  defp set(key, value) do
    Doex.Config.put(String.to_atom(key), value)
  end
end
