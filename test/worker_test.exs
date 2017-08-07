defmodule Doex.WorkerTest do
  use ExUnit.Case

  alias Doex.Worker

  setup do
    on_exit fn ->
      Application.delete_env(:doex, :config)
      Doex.reload
    end
    :ok
  end

  test "Store :config in worker" do
    Application.put_env(:doex, :config, %{token: "SHHHHH"})
    Doex.reload
    assert GenServer.call(Worker, :config) == %{token: "SHHHHH"}

    Application.put_env(:doex, :config, %{token: "NEW_SHHH"})
    assert GenServer.call(Worker, :config) == %{token: "SHHHHH"}

    GenServer.call(Worker, :reload)
    assert GenServer.call(Worker, :config) == %{token: "NEW_SHHH"}
  end
end