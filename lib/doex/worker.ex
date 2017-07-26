defmodule Doex.Worker do
  use GenServer

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
