defmodule QuarkTest do
  use ExUnit.Case
  doctest Quark

  test "greets the world" do
    assert Quark.hello() == :world
  end
end
