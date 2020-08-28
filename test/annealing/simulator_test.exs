defmodule Annealing.SimulatorTest do
  use ExUnit.Case
  doctest Annealing.Simulator
  alias Annealing.{Simulator, Metal}

  def distance(list) do
    list
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [{ax, ay}, {bx, by}] -> :math.pow(ax - bx, 2) + :math.pow(ay - by, 2) end)
    |> Enum.sum()
  end

  def square_sum(list) do
    list
    |> Enum.with_index()
    |> Enum.map(fn {x, i} -> :math.pow(2, x - i) end)
    |> Enum.sum()
  end

  test "list vectort distance energy calculation" do
    assert distance([{100, 120}, {20, 40}, {60, 200}, {40, 120}, {180, 200}]) == 72800
    assert square_sum([1, 2, 3, 4, 5, 6, 8, 7, 9, 10]) == 21
  end

  test "calculates the route with best eficiency" do
    list = [{60, 200}, {180, 200}, {40, 120}, {100, 120}, {20, 40}]
    metal = %Metal{list: list} |> Metal.energy(&distance/1)
    # IO.inspect(metal)
    result = Simulator.run(metal, 10_000, 0.01, &distance/1)
    # IO.inspect(result)
    assert result.energy < 33_000
  end

  test "sorts the list with best energy" do
    list = 1..10 |> Enum.shuffle()
    metal = %Metal{list: list} |> Metal.energy(&square_sum/1)
    # IO.inspect(metal)
    result = Simulator.run(metal, 10_000, 0.01, &square_sum/1)
    # IO.inspect(result)
    assert result.energy < 22
  end
end
