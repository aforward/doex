defmodule Doex.ConfigTest do
  use ExUnit.Case, async: false
  doctest Doex.Config

  alias Doex.Config

  @filename "/tmp/here/.doex"
  @default_config %{ssh_keys: [], token: "FILL_ME_IN", url: "https://api.digitalocean.com/v2"}

  setup do
    on_exit fn ->
      File.rm(".doex")
      File.rm("~/.doex" |> Path.expand)
      File.rm("/tmp/.doex")
      File.rm_rf("/tmp/here")
      System.delete_env("DOEX_CONFIG")
      Application.delete_env(:doex, :config)
      Doex.reload
    end
    :ok
  end

  test "filename (default)" do
    assert Config.filename == "~/.doex" |> Path.expand
  end

  test "filename (local directory)" do
    File.touch(".doex")
    assert Config.filename == ".doex" |> Path.expand
  end

  test "filename (SYSTEM ENV)" do
    File.touch(".doex")
    System.put_env("DOEX_CONFIG", @filename)
    assert Config.filename == @filename
  end

  test "filename (Application ENV)" do
    File.touch(".doex")
    Application.put_env(:doex, :config, %{token: "SHHHHH"})
    assert Config.filename == :config
  end

  test "init (use default filename)" do
    System.put_env("DOEX_CONFIG", @filename)
    Config.init
    assert File.exists?(@filename)
    assert @default_config == Config.read
  end

  test "init (file exists -- do nothing)" do
    System.put_env("DOEX_CONFIG", "/tmp/.doex")
    File.write!("/tmp/.doex", "xxx")
    Config.init
    assert "xxx" == File.read!("/tmp/.doex")
  end

  test "init (Application :config -- do nothing)" do
    Application.put_env(:doex, :config, %{token: "SHHHHH"})
    Config.init
    assert %{token: "SHHHHH"} == Config.read
  end

  test "reinit (file exists -- overwrite)" do
    System.put_env("DOEX_CONFIG", "/tmp/.doex")
    File.write!("/tmp/.doex", "xxx")
    Config.reinit
    assert @default_config == Config.read
  end

  test "reinit (Application :config -- do nothing)" do
    Application.put_env(:doex, :config, %{token: "SHHHHH"})
    Config.reinit
    assert %{token: "SHHHHH"} == Config.read
  end

  test "edit configs" do
    @filename |> Config.init

    :ok = Config.put(@filename, :token, "I_AM_FULL")
    assert "I_AM_FULL" == Config.get(@filename, :token)
    assert my_config(%{token: "I_AM_FULL"}) == Config.read(@filename)

    assert nil == Config.get(@filename, :apples)

    :ok = Config.put(@filename, :ssh_keys, ["abc", "def"])
    assert ["abc", "def"] == Config.get(@filename, :ssh_keys)
    assert my_config(%{ssh_keys: ["abc", "def"], token: "I_AM_FULL"}) == Config.read(@filename)

    :ok = Config.remove(@filename, :ssh_keys)
    assert nil == Config.get(@filename, :ssh_keys)
    assert %{token: "I_AM_FULL", url: "https://api.digitalocean.com/v2"} == Config.read(@filename)

  end

  test "get (Application :config -- do nothing)" do
    Application.put_env(:doex, :config, %{token: "SHHHHH", ssh_keys: ["ab1", "ab2"]})
    assert ["ab1", "ab2"] == Config.get(:config, :ssh_keys)
    assert %{token: "SHHHHH", ssh_keys: ["ab1", "ab2"]} == Config.read(:config)

    assert ["ab1", "ab2"] == Config.get(:ssh_keys)
    assert %{token: "SHHHHH", ssh_keys: ["ab1", "ab2"]} == Config.read
  end

  defp my_config(changes), do: Map.merge(@default_config, changes)

end
