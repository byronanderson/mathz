defmodule QuizMe do
  @moduledoc """
  Documentation for QuizMe.
  """

  @doc """
  QuizMe generates questions of the form "5 x _ = 20" and determines whether the 
  responses are correct.  Generation can be seeded for consistent responses

  ## Examples

      # iex> QuizMe.generate(1)
      

  """

  @operations [:x]

  def generate(seed \\ :os.timestamp) do
    seed = :rand.seed(:exsplus, seed)
    {op, seed} = random_operation(seed)
    case op do
      :x -> generate_multiplication_question(seed)
    end
  end

  def numbers_involved({_op, n1, n2, n3}) do
    [n1, n2, n3]
  end

  defp generate_multiplication_question(seed) do
    {n1, seed} = random_nonnegative_integer(99, seed)
    {n2, seed} = random_nonnegative_integer(99, seed)
    result = n1 * n2
    if result <= 99 do
      {:x, n1, n2, n1 * n2}
    else
      generate_multiplication_question(seed)
    end
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
