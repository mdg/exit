defmodule Exit do
  @moduledoc """
  Various iteration utilities

  Mostly wrappers for common patterns using Enum module
  """

  @doc """
  Convert a list of maps to a map of keys to the maps
  """
  @spec key_by([map()], term()) :: map()
  def key_by(items, key_f) when is_function(key_f) do
    Map.new(items, fn i -> {key_f.(i), i} end)
  end

  @doc """
  Convert a list of maps to a map of keys to the maps
  """
  @spec key_on([map()], term()) :: map()
  def key_on(items, key_name) when is_atom(key_name) do
    Map.new(items, fn i -> {Map.fetch!(i, key_name), i} end)
  end

  def key_on(items, key_name) when is_binary(key_name) do
    Map.new(items, fn i -> {Map.fetch!(i, key_name), i} end)
  end

  def key_on(items, index) when is_integer(index) do
    Map.new(items, fn
      i when is_tuple(i) -> {elem(i, index), i}
      i -> {Map.fetch!(i, index), i}
    end)
  end

  @doc """
  Rotate a list by moving the first item from the beginning to the end
  """
  @spec rotate([any()]) :: [any()]
  def rotate(items)

  def rotate([]), do: []

  def rotate([one]), do: [one]

  def rotate([a, b]), do: [b, a]

  def rotate([h | t]) do
    t ++ [h]
  end

  def rotate(items, n) do
    {h, t} = Enum.split(items, n)
    t ++ h
  end

  @doc """
  Rotate through items while each item is true for f
  """
  def rotate_while(items, f) do
    {h, t} = Enum.split_while(items, f)
    t ++ h
  end

  @doc """
  Rotate through items until the item is true for f
  """
  def rotate_until(items, f) do
    {h, t} = Enum.split_while(items, &(not f.(&1)))
    t ++ h
  end

  @spec map_to_id([term()]) :: [term()]
  def map_to_id(items) do
    Enum.map(items, & &1.id)
  end

  @spec reject_nil([term()]) :: [term()]
  def reject_nil(items) do
    Enum.reject(items, &is_nil/1)
  end

  @doc """
  Given 2 maps. zip them where the value is a tuple with the first and second
  elements belonging to the first and second maps, respectively.
  If a map does not have an element, the tuple will contain a nil.
  """
  def zip_maps(m0, m1) do
    first =
      Enum.reduce(m0, %{}, fn {k, v0}, acc ->
        Map.put(acc, k, {v0, nil})
      end)

    Enum.reduce(m1, first, fn {k, v1}, acc ->
      case Map.fetch(acc, k) do
        {:ok, {v0, _}} ->
          Map.put(acc, k, {v0, v1})

        :error ->
          Map.put(acc, k, {nil, v1})
      end
    end)
  end

  @doc """
  Zip 3 maps

  The same behavior as zip_maps/2 but with 3 maps.
  """
  def zip_maps(m0, m1, m2) do
    first =
      Enum.reduce(m0, %{}, fn {k, v0}, acc ->
        Map.put(acc, k, {v0, nil, nil})
      end)

    second =
      Enum.reduce(m1, first, fn {k, v1}, acc ->
        case Map.fetch(acc, k) do
          {:ok, {v0, _, _}} ->
            Map.put(acc, k, {v0, v1, nil})

          :error ->
            Map.put(acc, k, {nil, v1, nil})
        end
      end)

    Enum.reduce(m2, second, fn {k, v2}, acc ->
      case Map.fetch(acc, k) do
        {:ok, {v0, v1, _}} ->
          Map.put(acc, k, {v0, v1, v2})

        :error ->
          Map.put(acc, k, {nil, nil, v2})
      end
    end)
  end
end
