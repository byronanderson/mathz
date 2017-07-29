defmodule Runtime do
  def loop({wins, losses} \\ {0, 0}) do
    {op, [n1, n2, n3], answer} = QuizMe.generate()

    IO.puts "#{n1} #{op} #{n2} = #{n3}"

    {wins, losses} = if get_input() == answer do
      IO.puts "Yep!"
      {wins + 1, losses}
    else
      IO.puts "Nope, the answer was #{answer}"
      {wins, losses + 1}
    end
    inspect_score({wins, losses})
    loop({wins, losses})
  end

  defp get_input() do
    provided = IO.gets("> ") |> String.trim()

    case Integer.parse(provided) do
      {number, ""} ->
        number
      _ ->
        IO.puts "I don't recognize that response."
        get_input()
    end
  end

  defp inspect_score({wins, losses}) do
    IO.puts "Wins: #{wins}"
    IO.puts "Losses: #{losses}"
  end
end

Runtime.loop()
