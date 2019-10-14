defmodule Riot.PrinterTest do
  use Test.Support.RiotCase

  alias Riot.{MatchInfo, MatchState, Player, Printer}

  describe "format_matches_and_players" do
    test "it produces the desired output" do
      state = %MatchState{
        matches: [
          %MatchInfo{id: 12345, players: [opponent("A"), opponent("B")]},
          %MatchInfo{id: 54321, players: [opponent("B"), opponent("C")]}
        ],
        name: "LordTest"
      }

      output = Printer.format_matches_and_players(state)

      assert output ==
               "Last 5 matches for: LordTest\n" <>
                 "\n" <>
                 "Match: 12345\n" <>
                 "\n" <>
                 "Players:\n" <>
                 "OpponentA\n" <>
                 "OpponentB\n" <>
                 "\n" <>
                 "Match: 54321\n" <>
                 "\n" <>
                 "Players:\n" <>
                 "OpponentB\n" <>
                 "OpponentC\n"
    end
  end

  defp opponent(name), do: %Player{name: "Opponent#{name}"}
end
