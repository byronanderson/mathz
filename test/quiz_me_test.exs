defmodule QuizMeTest do
  use ExUnit.Case
  doctest QuizMe

  use ExUnit.Case, async: false
  use ExCheck

  test "is seeded random" do 
    seed = :os.timestamp()
    assert QuizMe.generate(seed) == QuizMe.generate(seed)
  end

  defp accurate?(quiz) do
    case quiz do
      {:x, n1, n2, n3} -> n1 * n2 == n3
      {:/, n1, n2, n3} -> n1 / n2 == n3
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
end