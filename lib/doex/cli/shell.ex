defmodule Doex.Cli.Shell do

  def cmd("doex") do
    if has_mix?() do
      "mix doex"
    else
      "doex"
    end
  end
  def cmd(raw_cmd) do
    if has_mix?() do
      String.replace(raw_cmd, "doex ", "mix doex.")
    else
      raw_cmd
    end
  end

  def info(msg) do
    if has_mix?() do
      Mix.shell.info(msg)
    else
      IO.puts(msg)
    end
  end

  def inspect(data, args), do: Enum.member?(args, "--quiet") |> _inspect(data)
  defp _inspect(false, data), do: IO.inspect(data)
  defp _inspect(true, data), do: data

  def error(msg) do
    if has_mix?() do
      Mix.shell.error(msg)
    else
      IO.puts(msg)
    end
  end

  def raise(msg) do
    if has_mix?() do
      Mix.raise(msg)
    else
      Kernel.raise(msg)
    end
  end

  def newline, do: info ""

  defp has_mix?, do: function_exported?(Mix, :shell, 1)
end