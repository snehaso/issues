defmodule Issues.CLI do
  @default_count 4

  def run(argv) do
    argv |>
    parse_args |>
    process
  end

  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])

    case parse do
      {[help: true], _, _} -> :help
      {_, [user, project, count], _} -> {user, project, count}
      {_, [user, project], _} -> { user, project, @default_count }
      _ -> :help
    end
  end

  def process(:help) do
    IO.puts """
      usage: issues <user> <project> [count | #{@default_count}]
    """
    System.halt(0)
  end

  def process({user, project, count}) do
    Issues.GitHubIssues.fetch(user, project) |>
    Enum.sort( fn(x, y) -> x["created_at"] <= y["created_at"] end) |>
    print_table
  end

  def print_table(dict) do
    IO.puts "Number  | Title | Create At"
    for d <- dict,
     do: IO.puts "#{d["number"]} | #{d["title"]}  | #{d["created_at"]}"
  end

end
