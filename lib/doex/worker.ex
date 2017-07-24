defmodule Doex.Worker do
  use GenServer

  ### Public API

  def start_link() do
    {:ok, _pid} = GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  ### Server Callbacks

  def init() do
    {:ok, {}}
  end

end
