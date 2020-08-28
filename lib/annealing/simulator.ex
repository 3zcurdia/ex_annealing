defmodule Annealing.Simulator do
  @moduledoc """
  Simulates annealing
  """
  alias Annealing.Metal

  def run(metal, current_temperature, cooling_rate, calculator) when is_list(metal) do
    %Metal{list: metal}
    |> Metal.energy(calculator)
    |> run(current_temperature, cooling_rate, calculator)
  end

  def run(%Metal{} = metal, temperature, cooling_rate, calculator)
      when temperature > cooling_rate do
    metal
    |> Metal.cooled(temperature, calculator)
    |> run(temperature - cooling_rate, cooling_rate, calculator)
  end

  def run(%Metal{} = metal, _temperature, _cooling_rate, _calculator), do: metal
end
