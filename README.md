# QuizMe

I recommend docker for running this because you might not have elixir:

To run the text UI, run this from the root of the repo:

`docker run -it --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp elixir mix run quizme.exs`

To run the tests:

`docker run -it --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp elixir mix test`

