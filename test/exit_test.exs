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

  describe "rotate_while/2" do
    test "rotates numbers while less than threshold" do
      # Rotate while numbers are less than 5
      # [1, 2, 3, 4, 8, 9] -> [8, 9, 1, 2, 3, 4]
      items = [1, 2, 3, 4, 8, 9]
      actual = Exit.rotate_while(items, &(&1 < 5))

      assert actual == [8, 9, 1, 2, 3, 4]
    end

    test "handles empty list" do
      # Empty list should return empty list
      actual = Exit.rotate_while([], &(&1 > 0))

      assert actual == []
    end

    test "rotates all items when condition always true" do
      # All items match condition, so all items move to end (effectively no change)
      # [1, 2, 3] -> [1, 2, 3] (all items rotated to end)
      items = [1, 2, 3]
      actual = Exit.rotate_while(items, &(&1 > 0))

      assert actual == [1, 2, 3]
    end

    test "no rotation when first item fails condition" do
      # First item doesn't match condition, so no rotation occurs
      # [10, 1, 2, 3] with condition < 5 -> [10, 1, 2, 3] (no change)
      items = [10, 1, 2, 3]
      actual = Exit.rotate_while(items, &(&1 < 5))

      assert actual == [10, 1, 2, 3]
    end

    test "rotates active user hands to find next player" do
      # Practical example: finding next active player after a specific user
      # Simulating user hands where we want to rotate past inactive users
      user_hands = [
        %{user_id: 1, status: :away},    # will be rotated
        %{user_id: 2, status: :away},    # will be rotated
        %{user_id: 3, status: :active},  # first non-away user
        %{user_id: 4, status: :active}
      ]

      # Rotate while users are away (inactive)
      actual = Exit.rotate_while(user_hands, &(&1.status == :away))

      expected = [
        %{user_id: 3, status: :active},
        %{user_id: 4, status: :active},
        %{user_id: 1, status: :away},
        %{user_id: 2, status: :away}
      ]

      assert actual == expected
    end
  end
end
