defmodule DoexTest do
  use ExUnit.Case
  # doctest Doex

  setup do
    on_exit fn ->
      Application.delete_env(:doex, :config)
    end
    :ok
  end

  test "versions" do
    assert Doex.version == Mix.Project.config[:version]
    assert Doex.elixir_version == System.version
  end

  test "config (from worker)" do
    Application.put_env(:doex, :config, %{token: "SHHHHH"})
    Doex.reload
    assert Doex.config == %{token: "SHHHHH"}

    Application.put_env(:doex, :config, %{token: "NEW_SHHH"})
    assert Doex.config == %{token: "SHHHHH"}

    Doex.reload
    assert Doex.config == %{token: "NEW_SHHH"}
  end

end
