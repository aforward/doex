defmodule Mix.Tasks.DoexTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  test "run without args shows help" do
    assert capture_io(fn ->
      Mix.Tasks.Doex.run([])
    end) == """
doex v#{Doex.version}
doex is a API client for Digital Ocean's API v2.

Further information can be found here:
  -- https://hex.pm/packages/doex
  -- https://github.com/capbash/doex

"""
  end

  test "run with invalid arguments" do
    assert capture_io(:stderr, fn ->
      Mix.Tasks.Doex.run(["goop"])
    end) == "\e[31m\e[1mInvalid arguments, expected: mix dio\e[0m\n"
  end
end
