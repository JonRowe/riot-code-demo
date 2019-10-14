defmodule Riot.Printer do
  alias Riot.{MatchInfo, MatchState, Player}

  def format_matches_and_players(%MatchState{name: name, matches: matches}) do
    "Last 5 matches for: #{name}\n\n" <>
      "#{join(matches, &format_match/1)}"
  end

  def format_match(%MatchInfo{id: id, players: players}) do
    "Match: #{id}\n\n" <>
      "Players:\n#{join(players, &format_player/1)}\n"
  end

  def format_player(%Player{name: name}) do
    name
  end

  defp join(collection, function) do
    collection
    |> Enum.map(function)
    |> Enum.join("\n")
  end
end
