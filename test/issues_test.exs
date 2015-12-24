defmodule IssuesTest do
  use ExUnit.Case
  doctest Issues

  import Issues.CLI, only: [parse_args: 1]

  test ":help returned by option parser with -h or --help options" do
    parse_args(["-h", "anything anywhere"]) == :help
    parse_args(["--help", "anything anywhere"]) == :help
  end

  test "three values returned if three are given" do
    parse_args(['sneha', 'issues project', 5]) == { 'sneha', 'issues project', 5}
  end

  test 'return default count if third value is not given' do
    parse_args(['sneha', 'issues project']) == {'sneha', 'issues project', 4}
  end

end
