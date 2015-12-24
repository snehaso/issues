defmodule Issues.GitHubIssues do
  @user_agent  [{ "User-agent", "Elixir snehasomwanshi@gmail.com"}]

  def fetch(user, project) do
    "https://api.github.com/repos/#{user}/#{project}/issues" |>
    HTTPoison.get(@user_agent) |>
    handle_response
  end

  def handle_response({:ok, %{status_code: 200, body: body}}) do
    :jsx.decode(body) |>
    Enum.map(&Enum.into(&1, HashDict.new))
  end

  def handle_response({:ok, %{status_code: _, body: body}}) do
    {_, message} = List.keyfind(:jsx.decode(body), "message", 0)
    IO.puts "GitHub failed with error: #{message}"
    System.halt(2)
  end
end
