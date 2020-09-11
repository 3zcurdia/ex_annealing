defmodule Annealing do
  @moduledoc """
  Documentation for `Annealing`.
  """
  alias Annealing.{Metal, Simulator}

  def main(_args) do
    list = [{60, 200}, {180, 200}, {40, 120}, {100, 120}, {20, 40}]
    metal = %Metal{list: list} |> Metal.energy(&distance/1)
    IO.inspect(metal)
    result = Simulator.run(metal, 10_000, 0.01, &distance/1)
    IO.inspect(result)
  end

  def distance(list) do
    list
    |> Stream.chunk_every(2, 1, :discard)
    |> Task.async_stream(fn [{ax, ay}, {bx, by}] -> :math.pow(ax - bx, 2) + :math.pow(ay - by, 2) end)
    |> Enum.map(fn {:ok, val} -> val end)
    |> Enum.sum()
  end
end
