defmodule Doex.ConfigTest do
  use ExUnit.Case, async: false
  doctest Doex.Config

  alias Doex.Config

  @filename "/tmp/here/.doex"

  setup do
    on_exit fn ->
      File.rm(".doex")
      File.rm("/tmp/.doex")
      File.rm_rf("/tmp/here")
      System.delete_env("DOEX_CONFIG")
    end
    :ok
  end

  test "filename (default)" do
    assert Config.filename == "~/.doex"
  end

  test "filename (local directory)" do
    File.touch(".doex")
    assert Config.filename == ".doex"
  end

  test "filename (SYSTEM ENV)" do
    File.touch(".doex")
    System.put_env("DOEX_CONFIG", @filename)
    assert Config.filename == @filename
  end

  test "init (use default filename)" do
    System.put_env("DOEX_CONFIG", @filename)
    Config.init
    assert File.exists?(@filename)
    assert %{ssh_keys: [], token: "FILL_ME_IN"} == Config.read
  end

  test "init (file exists -- do nothing)" do
    System.put_env("DOEX_CONFIG", "/tmp/.doex")
    File.write!("/tmp/.doex", "xxx")
    Config.init
    assert "xxx" == File.read!("/tmp/.doex")
  end

  test "reinit (file exists -- overwrite)" do
    System.put_env("DOEX_CONFIG", "/tmp/.doex")
    File.write!("/tmp/.doex", "xxx")
    Config.reinit
    assert %{ssh_keys: [], token: "FILL_ME_IN"} == Config.read
  end


  test "edit configs" do
    @filename |> Config.init

    :ok = Config.put(@filename, :token, "I_AM_FULL")
    assert "I_AM_FULL" == Config.get(@filename, :token)
    assert %{ssh_keys: [], token: "I_AM_FULL"} == Config.read(@filename)

    assert nil == Config.get(@filename, :apples)

    :ok = Config.put(@filename, :ssh_keys, ["abc", "def"])
    assert ["abc", "def"] == Config.get(@filename, :ssh_keys)
    assert %{ssh_keys: ["abc", "def"], token: "I_AM_FULL"} == Config.read(@filename)

    :ok = Config.remove(@filename, :ssh_keys)
    assert nil == Config.get(@filename, :ssh_keys)
    assert %{token: "I_AM_FULL"} == Config.read(@filename)

  end


end
