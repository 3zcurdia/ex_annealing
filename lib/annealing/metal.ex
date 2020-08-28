defmodule Annealing.Metal do
  defstruct [:list, :energy]

  @moduledoc """
  Simulates all metal actions
  """
  alias Annealing.Metal

  @doc """
  It returns a cooled a metal with a better energy
  """
  @spec cooled(map, integer, function) :: map
  def cooled(metal, temperature, calcuator) do
    cooled_metal = metal |> cool() |> energy(calcuator)

    if better_than?(metal, cooled_metal, temperature) do
      cooled_metal
    else
      metal
    end
  end

  @doc """
  Determinated if a metal is better than other, based on energy delta and coeficient

  ## Examples

      iex> Annealing.Metal.better_than?(%Annealing.Metal{energy: 10}, %Annealing.Metal{energy: 100}, 2_000)
      true
      iex> Annealing.Metal.better_than?(%Annealing.Metal{energy: 10}, %Annealing.Metal{energy: 10_000}, 2_000)
      false
  """
  @spec better_than?(map, map, float) :: atom
  def better_than?(%Metal{energy: current}, %Metal{energy: next}, temperature) do
    delta = current - next
    delta > 0 || :math.exp(delta / temperature) > :rand.uniform_real()
  end

  @doc """
  It returns the energy of a metal or calculates using the function
  """
  @spec energy(map, function) :: map
  def energy(%Metal{list: list, energy: energy} = metal, calc) when is_nil(energy) do
    %Metal{metal | energy: calc.(list)}
  end

  def energy(%Metal{} = metal, _calc), do: metal

  @doc """
  It cools down a metal
  """
  @spec cool(map) :: map
  def cool(%Metal{list: list}) do
    %Metal{list: random_swap(list)}
  end

  @doc """
  It random swap two elements of a list
  """
  @spec random_swap(list) :: list
  def random_swap(list) do
    max = length(list) - 1
    index_a = Enum.random(0..max)
    index_b = Enum.random(0..max)
    swap(list, index_a, index_b)
  end

  @doc """
  It swaps an element of an array

  ## Examples

      iex> Annealing.Metal.swap([1,2,3,4,5], 1, 3)
      [1,4,3,2,5]

  """
  @spec swap(list, integer, integer) :: list
  def swap(list, index_a, index_b) do
    value_a = Enum.at(list, index_a)
    value_b = Enum.at(list, index_b)

    list
    |> List.insert_at(index_a, value_b)
    |> List.delete_at(index_a + 1)
    |> List.insert_at(index_b, value_a)
    |> List.delete_at(index_b + 1)
  end
end
