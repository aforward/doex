defmodule Doex do
  @moduledoc"""
  A client library for interacting with the Digital Ocean API.

  Before you get started, you will need to configure access to your Digital Ocean
  account.  For this, you will need your [API TOKEN](https://www.digitalocean.com/community/tutorials/how-to-use-the-digitalocean-api-v2#how-to-generate-a-personal-access-token)

  Let's say your token is ABC123, then configure it as follows:

      mix doex.init
      mix doex.config token ABC123

  And to confirm it's set, run

      mix doex.config

  And the output should look similar to:

      ssh_keys: []
      token: "ABC123"
      url: "https://api.digitalocean.com/v2"

  We can now start a iEX session, `iex -S mix`, and confirm the information above

      iex> Doex.config
      %{ssh_keys: [], token: "ABC123", url: "https://api.digitalocean.com/v2"}

  The underlying API calls are made through

      Doex.Api

  You only need to provide the endpoint after the `/v2`, so to access your account
  you would run

      iex> Doex.Api.get("/account")

  OR, you encode the method, and make the same call like

      iex> Doex.Api.call(:get, %{source: "/account"})

  If your configurations are message up (or other errors occur), it will look
  similar to

      {:error,
       "Expected a 200, received 401",
       %{"id" => "unauthorized", "message" => "Unable to authenticate you."}}

  If things are working as expected, a success message looks like

      {:ok,
       %{"account" => %{"droplet_limit" => 99, "email" => "me@example.com",
           "email_verified" => true, "floating_ip_limit" => 5, "status" => "active",
           "status_message" => "",
           "uuid" => "abcdefghabcdefghabcdefghabcdefghabcdefgh"}}}

  The underlying configs are stored in a `Doex.Worker` and can be reloaded using

      Doex.reload

  At present, there are no client specific convenience methods, but when there are
  they will be located in

      Doex.Client

  """

  def version(), do: unquote(Mix.Project.config[:version])
  def elixir_version(), do: unquote(System.version)


  @doc"""
  Retrieve the DOEX configs.
  """
  def config do
    GenServer.call(Doex.Worker, :config)
  end

  @doc"""
  Reload the DOEX configs from the defaulted location
  """
  def reload, do: GenServer.call(Doex.Worker, :reload)
  def reload(filename), do: GenServer.call(Doex.Worker, {:reload, filename})

end
