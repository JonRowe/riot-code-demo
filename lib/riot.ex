defmodule Riot do
  @moduledoc """
  Riot Code Test.
  """

  alias Riot.{MatchState, Printer}

  require Logger

  def find_recent_played_with_matches(name) do
    name
    |> MatchState.for_player()
    |> print()
  end

  defp print(state = %MatchState{}) do
    state
    |> Printer.format_matches_and_players()
    |> Logger.info()
  end

  defp print({:error, error}), do: Logger.error(error)
end
