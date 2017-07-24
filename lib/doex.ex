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

  If you API is not complete, then you would also expose direct access to your
  Worker calls:

    defdelegate http(method, data), to: Doex.Worker
    defdelegate post(url, body, headers), to: Doex.Worker
    defdelegate get(url, headers), to: Doex.Worker
  """

end
