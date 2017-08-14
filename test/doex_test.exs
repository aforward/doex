defmodule DoexTest do
  use ExUnit.Case

  setup do
    on_exit fn ->
      Application.delete_env(:doex, :config)
      Doex.reload
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

  test "testing .git/hooks/post-commit" do
    # TESTING, that fail on purpose to ensure we don't publish
    # assert 1 == 2

    # TESTING, that passing and we do publish
    assert 1 == 1
  end

end
