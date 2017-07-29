{op, n1, n2, n3} = QuizMe.generate()

missing = Enum.random(1..3)

{prompt, answer} = case missing do
  1 -> {"_ #{op} #{n2} = #{n3}", n1}
  2 -> {"#{n1} #{op} _ = #{n3}", n2}
  3 -> {"#{n1} #{op} #{n2} = _", n3}
end

IO.puts prompt

provided = IO.gets("> ") |> String.trim()

case Integer.parse(provided) do
  {^answer, ""} -> IO.puts "Yep!"
  {_number, ""} -> IO.puts "Nope, the answer was #{answer}"
  _ -> IO.puts "I don't recognize that response."
end
