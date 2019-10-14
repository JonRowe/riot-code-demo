defmodule Riot do
  @moduledoc """
  Riot Code Test.
  """

  alias Riot.{MatchInfo, MatchState, Printer, Server, Timer}

  require Logger

  def find_recent_played_with_matches(name) do
    name
    |> MatchState.for_player()
    |> setup_monitoring()
    |> print()
  end

  defp setup_monitoring(state = %MatchState{matches: matches}) do
    {:ok, pid} =
      matches
      |> Enum.flat_map(fn %MatchInfo{players: players} -> players end)
      |> Server.watch()

    Timer.send(pid, :check)

    state
  end

  defp print(state = %MatchState{}) do
    state
    |> Printer.format_matches_and_players()
    |> Logger.info()
  end

  defp print({:error, error}), do: Logger.error(error)
end
