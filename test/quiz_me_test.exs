defmodule QuizMeTest do
  use ExUnit.Case
  doctest QuizMe

  use ExUnit.Case, async: false
  use ExCheck

  test "is seeded random" do 
  	seed = :os.timestamp()
  	assert QuizMe.generate(seed) == QuizMe.generate(seed)
  end

  property :all_numbers_integers do
  	for_all random_seed in int() do
  	  QuizMe.generate({random_seed, random_seed, random_seed})
  	  |> QuizMe.numbers_involved()
  	  |> Enum.all?(fn num -> is_integer(num) end)
	end
  end

  property :all_numbers_less_than_100 do
  	for_all random_seed in int() do
  	  QuizMe.generate({random_seed, random_seed, random_seed})
  	  |> QuizMe.numbers_involved()
  	  |> Enum.all?(fn num -> num < 100 end)
	end
  end

  # property :all_numbers_positive do
  # end
end