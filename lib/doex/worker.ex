defmodule Doex.Worker do
  use GenServer

  ### Public API

  def start_link() do
    {:ok, _pid} = GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def http(method, data) do
    GenServer.call(Doex.Worker, {:http, method, data})
  end

  def post(url, body, headers) do
    GenServer.call(Doex.Worker, {:post, url, body, headers})
  end

  def get(url, headers) do
    GenServer.call(Doex.Worker, {:get, url, headers})
  end

  ### Server Callbacks

  def init() do
    {:ok, {}}
  end

  def handle_call({:http, method, data}, _from, state) do
    answer = Doex.Api.call(method, data)
    {:reply, answer, state}
  end

  def handle_call({:post, url, body, headers}, _from, state) do
    answer = Doex.Api.post(url, body, headers)
    {:reply, answer, state}
  end

  def handle_call({:get, url, headers}, _from, state) do
    answer = Doex.Api.get(url, headers)
    {:reply, answer, state}
  end

end
