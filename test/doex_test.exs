defmodule DoexTest do
  use ExUnit.Case
  # doctest Doex

  test "versions" do
    assert Doex.version == Mix.Project.config[:version]
    assert Doex.elixir_version == System.version
  end

end
