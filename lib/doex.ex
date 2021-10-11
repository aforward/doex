defmodule Doex do
  @external_resource "README.md"
  @moduledoc "README.md"
             |> File.read!()
             |> String.split("<!-- MDOC !-->")
             |> Enum.fetch!(1)

  def version(), do: unquote(Mix.Project.config()[:version])
  def elixir_version(), do: unquote(System.version())

  def start(), do: {:ok, _started} = Application.ensure_all_started(:doex)

  @doc """
  Retrieve the DOEX configs.
  """
  def config do
    GenServer.call(Doex.Worker, :config)
  end

  @doc """
  Reload the DOEX configs from the defaulted location
  """
  def reload, do: GenServer.call(Doex.Worker, :reload)
  def reload(filename), do: GenServer.call(Doex.Worker, {:reload, filename})
end
