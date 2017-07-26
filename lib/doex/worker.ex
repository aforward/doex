defmodule Doex.Worker do
  use GenServer

  @moduledoc"""
  Provides global access to the loaded configs, the API
  is available directly with `Doex`, so there is little need to
  dive too deep into here to learn how to use the API, but
  rather for understanding the internals of the project.

  To lookup the loaded configs (or to load them for the first time),

        Doex.config

  Which will call

        GenServer.call(Doex.Worker, :config)

  To force a reload on the global configs,

        Doex.reload

  Which will call

        GenServer.call(Doex.Worker, :reload)

  If you wanted to load a different config file, then,

        Doex.reload("/path/to/new/file.doex")

  Which will call

        GenServer.call(Doex.Worker, {:reload, "/path/to/new/file.doex"})
  """

  def start_link() do
    {:ok, _pid} = GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    {:ok, %{}}
  end

  def handle_call(:config, _from, state) do
    case state[:config] do
      nil -> read_config(state)
      c -> {:reply, c, state}
    end
  end

  def handle_call(:reload, _from, _state) do
    {:reply, :ok, %{config: Doex.Config.read}}
  end

  def handle_call({:reload, filename}, _from, _state) do
    {:reply, :ok, %{config: Doex.Config.read(filename)}}
  end

  defp read_config(state) do
    config = Doex.Config.read
    {:reply, config, Map.put(state, :config, config)}
  end


end
