defmodule ExitTest do
  use ExUnit.Case
  doctest Exit

  test "key_by func" do
    actual = Exit.key_by([%{a: 5, b: 8}, %{a: 7, c: 3}], &Map.get(&1, :a))
    assert actual == %{5 => %{a: 5, b: 8}, 7 => %{a: 7, c: 3}}
  end

  test "zip 3" do
    m1 = %{"a" => "a1", "ab" => "ab1", "ac" => "ac1", "abc" => "abc1"}
    m2 = %{"b" => "b2", "ab" => "ab2", "bc" => "bc2", "abc" => "abc2"}
    m3 = %{"c" => "c3", "ac" => "ac3", "bc" => "bc3", "abc" => "abc3"}
    actual = Exit.zip_maps(m1, m2, m3)

    assert Map.fetch!(actual, "a") == {"a1", nil, nil}
    assert Map.fetch!(actual, "b") == {nil, "b2", nil}
    assert Map.fetch!(actual, "c") == {nil, nil, "c3"}

    assert Map.fetch!(actual, "ab") == {"ab1", "ab2", nil}
    assert Map.fetch!(actual, "bc") == {nil, "bc2", "bc3"}
    assert Map.fetch!(actual, "ac") == {"ac1", nil, "ac3"}

    assert Map.fetch!(actual, "abc") == {"abc1", "abc2", "abc3"}
  end
end
