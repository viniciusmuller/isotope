defmodule NoisexTest do
  use ExUnit.Case
  doctest Noisex

  test "greets the world" do
    assert Noisex.hello() == :world
  end
end
