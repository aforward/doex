defmodule Mix.Tasks.DoexTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  test "run without args shows help" do
    assert capture_io(fn ->
      Mix.Tasks.Doex.run([])
    end) =~ "doex v#{Doex.version}"
  end

  test "run with invalid arguments" do
    assert capture_io(:stderr, fn ->
      Mix.Tasks.Doex.run(["goop"])
    end) =~ "Invalid arguments, expected: mix dio"
  end
end
