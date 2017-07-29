defmodule Runtime do
  def loop() do
    {op, [n1, n2, n3], answer} = QuizMe.generate()

    IO.puts "#{n1} #{op} #{n2} = #{n3}"

    provided = IO.gets("> ") |> String.trim()

    case Integer.parse(provided) do
      {^answer, ""} -> IO.puts "Yep!"
      {_number, ""} -> IO.puts "Nope, the answer was #{answer}"
      _ -> IO.puts "I don't recognize that response."
    end
    loop()
  end
end

Runtime.loop()
