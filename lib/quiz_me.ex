defmodule QuizMe do
  @moduledoc """
  Documentation for QuizMe.
  """

  @doc """
  QuizMe generates questions of the form "5 x _ = 20" and determines whether the 
  responses are correct.  Generation can be seeded for consistent responses
  """

  @operations [:+, :-, :x, :/]

  def generate(seed \\ :os.timestamp) do
    seed = :rand.seed(:exsplus, seed)
    {equation, seed} = generate_equation(seed)
    {question, _seed} = generate_question(equation, seed)
    question
  end

  defp generate_equation(seed) do
    {op, seed} = random_operation(seed)
    case op do
      :x -> generate_multiplication_question(seed)
      :+ -> generate_addition_question(seed)
      :/ -> generate_division_question(seed)
      :- -> generate_subtraction_question(seed)
    end
  end

  defp generate_question({op, n1, n2, n3}, seed) do
    {missing, seed} = random_nonnegative_integer(2, seed)

    {positions, answer} = case missing do
      0 -> {[:_, n2, n3], n1}
      1 -> {[n1, :_, n3], n2}
      2 -> {[n1, n2, :_], n3}
    end

    {{op, positions, answer}, seed}
  end

  def equation({op, positions, answer}) do
    [n1, n2, n3] = Enum.map(positions, fn position ->
      if position == :_ do
        answer
      else
        position
      end
    end)
    {op, n1, n2, n3}
  end

  def numbers_involved({_op, positions, answer}) do
    [answer | Enum.filter(positions, fn position -> is_integer(position) end)]
  end

  def positions({_op, positions, _answer}) do
    positions
  end

  defp generate_multiplication_question(seed) do
    {n1, seed} = random_nonnegative_integer(40, seed)
    {n2, seed} = random_nonnegative_integer(40, seed)
    result = n1 * n2
    if result <= 99 do
      {{:x, n1, n2, result}, seed}
    else
      generate_multiplication_question(seed)
    end
  end

  defp generate_division_question(seed) do
    {{:x, n1, n2, n3}, seed} = generate_multiplication_question(seed)
    if n3 == 0 do
      generate_division_question(seed)
    else
      {{:/, n3, n2, n1}, seed}
    end
  end

  defp generate_addition_question(seed) do
    {n1, seed} = random_nonnegative_integer(99, seed)
    {n2, seed} = random_nonnegative_integer(99, seed)
    result = n1 + n2
    if result <= 99 do
      {{:+, n1, n2, result}, seed}
    else
      generate_addition_question(seed)
    end
  end

  defp generate_subtraction_question(seed) do
    {n1, seed} = random_nonnegative_integer(99, seed)
    {n2, _seed} = random_nonnegative_integer(99, seed)
    {min, max} = Enum.min_max([n1, n2])
    result = max - min
    {{:-, max, min, result}, seed}
  end

  defp random_operation(seed) do
    {index, seed} = :rand.uniform_s(Enum.count(@operations), seed)
    op = Enum.at(@operations, index - 1)
    {op, seed}
  end

  defp random_nonnegative_integer(max_val, seed) do
    {val, seed} = :rand.uniform_s(max_val, seed)
    {val - 1, seed}
  end
end
