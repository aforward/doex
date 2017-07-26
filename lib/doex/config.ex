defmodule Doex.Config do

  use FnExpr

  @moduledoc"""
  There are a few ways to configure access to your Digital Ocean
  account.  First, you should go and find your [API TOKEN](https://www.digitalocean.com/community/tutorials/how-to-use-the-digitalocean-api-v2#how-to-generate-a-personal-access-token)

  Let's say your token is ABC123, then you can configure you application
  through Mix Tasks, as follows:

      mix doex.init
      mix doex.config token ABC123

  And to confirm it's set, run

      mix doex.config

  And the output should look similar to:

      ssh_keys: []
      token: "ABC123"
      url: "https://api.digitalocean.com/v2"

  You can achieve similar behvarious through an iEX session `iex -S mix`

      Doex.Config.init
      "/Users/aforward/.doex"

      Doex.Config.put(:token, "ABC123")
      :ok

      Doex.Config.read
      %{ssh_keys: [], token: "ABC123", url: "https://api.digitalocean.com/v2"}

  The information above is cached in the Doex.Worker, so if you are making changes
  in iEX, you can reload your configs using

      iex> Doex.reload
      :ok

  And you can see the currently cached values with

      Doex.config
      %{ssh_keys: [], token: "ABC123", url: "https://api.digitalocean.com/v2"}

  The order of preference for locating the appropriate configs are

      #1 Environment variable storing the path to the file
      DOEX_CONFIG=/tmp/my.doex

      #2 Elixir built in Mix.Config
      use Mix.Config
      config :doex, config:  %{token: "SHHHHH"}

      #3 A file within "myproject" called .doex
      /src/myproject/.doex

      # A file within the home directory called .doex
      ~/.doex

  You could overwrite the location, but that's mostly for testing, so unless you have
  a really valid reason do to so, please don't.
  """

  @default_filename "~/.doex"

  def filename do
    case Application.get_env(:doex, :config) do
      nil -> case System.get_env("DOEX_CONFIG") do
               nil -> lookup_filename()
               f -> f
             end
             |> Path.expand
      _ -> :config
    end
  end

  def init(), do: filename() |> init
  def init(:config), do: :config
  def init(filename) do
    :ok = filename |> Path.dirname |> File.mkdir_p!

    unless File.exists?(filename) do
      filename |> reinit
    end
    filename
  end

  def reinit(), do: filename() |> reinit
  def reinit(:config), do: :config
  def reinit(filename) do
    :ok = write(filename, default_config())
    filename
  end

  def get(key), do: filename() |> get(key)
  def get(:config, key), do: read() |> Map.get(key)
  def get(filename, key) do
    filename
    |> Path.expand
    |> init
    |> read
    |> Map.get(key)
  end

  def put(key, value), do: filename() |> put(key, value)
  def put(:config, _key, _value), do: {:error, :readonly}
  def put(filename, key, value) do
    filename
    |> Path.expand
    |> init
    |> read
    |> Map.merge(%{key => value})
    |> invoke(fn map -> write(filename, map) end)
  end

  def remove(key), do: filename() |> remove(key)
  def remove(:config, _key), do: {:error, :readonly}
  def remove(filename, key) do
    filename
    |> Path.expand
    |> init
    |> read
    |> Map.delete(key)
    |> invoke(fn map -> write(filename, map) end)
  end

  def read(), do: filename() |> read
  def read(:config), do: Application.get_env(:doex, :config)
  def read(filename) do
    filename
    |> Path.expand
    |> File.read
    |> invoke(fn result ->
         case result do
           {:ok, content} -> :erlang.binary_to_term(content)
           {:error, _} -> default_config()
         end
       end)
  end

  defp lookup_filename do
    [
      ".doex",
    ]
    |> Enum.filter(&File.exists?/1)
    |> Enum.fetch(0)
    |> case do
      :error -> @default_filename
      {:ok, f} -> f
    end
  end

  defp write(filename, map) do
    filename
    |> Path.expand
    |> File.write!(:erlang.term_to_binary(map))
  end

  defp default_config do
    %{
        token: "FILL_ME_IN",
        ssh_keys: [],
        url: "https://api.digitalocean.com/v2"
     }
  end

end
