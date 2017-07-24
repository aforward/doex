defmodule Doex do
  @moduledoc"""
  A client library for interacting with the Doex API.

  The underlying HTTP calls and done through

    Doex.Api

  Which are wrapped in a GenServer in

    Doex.Worker

  And client specific access should be placed in

    Doex.Client

  Your client wrapper methods should be exposed here, using defdelegate,
  for example

    defdelegate do_something, to: Doex.Client

  """

  def version(), do: unquote(Mix.Project.config[:version])
  def elixir_version(), do: unquote(System.version)

end
