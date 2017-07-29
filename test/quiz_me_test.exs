defmodule QuizMeTest do
  use ExUnit.Case
  doctest QuizMe

  use ExUnit.Case, async: false
  use ExCheck

  test "is seeded random" do 
    seed = :os.timestamp()
    assert QuizMe.generate(seed) == QuizMe.generate(seed)
    assert QuizMe.generate(seed) != QuizMe.generate({1, 2, 3})
  end

  defp accurate?(quiz) do
    case QuizMe.equation(quiz) do
      {:x, n1, n2, n3} -> n1 * n2 == n3
      {:/, n1, n2, n3} -> n2 != 0 && n1 / n2 == n3
      {:+, n1, n2, n3} -> n1 + n2 == n3
      {:-, n1, n2, n3} -> n1 - n2 == n3
    end
  end

  property :accurate do
    for_all random_seed in int() do
      QuizMe.generate({random_seed, random_seed, random_seed})
      |> accurate?()
    end
  end

  property :all_numbers_integers do
    for_all random_seed in int() do
      QuizMe.generate({random_seed, random_seed, random_seed})
      |> QuizMe.numbers_involved()
      |> Enum.all?(fn num -> is_integer(num) end)
    end
  end

  property :all_numbers_between_0_and_99 do
    for_all random_seed in int() do
      QuizMe.generate({random_seed, random_seed, random_seed})
      |> QuizMe.numbers_involved()
      |> Enum.all?(fn num -> num < 100 && num >= 0 end)
    end
  end

  property :hides_one_position do
    for_all random_seed in int() do
      QuizMe.generate({random_seed, random_seed, random_seed})
      |> QuizMe.positions()
      |> Enum.count(fn position -> position == :_ end) == 1
    end
  end

  property :only_one_answer do
    for_all random_seed in int() do
      {op, positions, _} = QuizMe.generate({random_seed, random_seed, random_seed})
      Enum.count(0..99, fn answer -> accurate?({op, positions, answer}) end) == 1
    end
  end
end