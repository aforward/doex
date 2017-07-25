defmodule Mix.Tasks.Doex.Init do
  use Mix.Task

  @shortdoc "Initialize your doex config"

  def run(_) do
    filename = Doex.Config.init
    IO.puts "DOEX config initialized, and stored in"
    IO.puts "  -- #{filename}"
    IO.puts ""
  end

end
