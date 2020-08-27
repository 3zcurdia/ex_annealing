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
  def better_than?(%Metal{} = a, %Metal{} = b, temperature) do
    diff = delta(a, b)
    diff > 0 || coef(diff, temperature) > :rand.uniform_real()
  end

  @euler 2.718281828459045

  @doc """
  Determinated the coeficient of temperature with a given delta

  ## Examples

      iex> Annealing.Metal.coef(10, 1000)
      1.010050167084168
  """
  def coef(delta, temperature), do: :math.pow(@euler, delta/temperature)


  @doc """
  Calculates the delta energy between metals

  ## Examples

      iex> Annealing.Metal.delta(%Annealing.Metal{energy: 4}, %Annealing.Metal{energy: 3})
      1
      iex> Annealing.Metal.delta(%Annealing.Metal{energy: 3}, %Annealing.Metal{energy: 4})
      -1
  """
  def delta(%Metal{energy: left}, %Metal{energy: right}), do: left - right

  @doc """
  It returns the energy of a metal or calculates using the function
  """
  @spec energy(map, function) :: map
  def energy(%Metal{list: list, energy: nil} = metal, calc) do
    %Metal{metal| energy: calc.(list)}
  end
  def energy(%Metal{} = metal , _calc), do: metal

  @doc """
  It cools down a metal
  """
  @spec cool(map) :: map
  def cool(%Metal{list: list} = metal) do
    %Metal{metal | list: random_swap(list)}
  end

  @doc """
  It random swap two elements of a list
  """
  @spec random_swap(list) :: list
  def random_swap(list) do
    max = length(list) - 1
    index_a = uniq_rand(max)
    index_b = uniq_rand(max, index_a)
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

  defp uniq_rand(limit), do: :rand.uniform(limit)
  defp uniq_rand(1, 1), do: 1
  defp uniq_rand(limit, except) when except > limit, do: :rand.uniform(limit)

  defp uniq_rand(limit, except) do
    value = :rand.uniform(limit)

    if value == except do
      uniq_rand(limit, except)
    else
      value
    end
  end
end
