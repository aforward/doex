defmodule Doex.Cli.Imagelets.CreateTest do
  use ExUnit.Case
  alias Doex.Cli.Imagelets.Create

  test "extract linux distribution from name" do
    assert :trusty == Create.linux_distribution("ubuntu-14-04-x64")
    assert :xenial == Create.linux_distribution("ubuntu-16-04-x64")
    assert :bionic == Create.linux_distribution("ubuntu-18-04-x64")

    assert :trusty == Create.linux_distribution("xx-ubuntu-14-04-xx")
    assert :xenial == Create.linux_distribution("yy-ubuntu-16-04-yy")
    assert :bionic == Create.linux_distribution("zz-ubuntu-18-04-zz")

    assert nil == Create.linux_distribution(nil)
    assert nil == Create.linux_distribution("")
    assert nil == Create.linux_distribution("goop")
  end
end
