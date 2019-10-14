defmodule Riot.MatchInfo do
  defstruct id: nil, players: []

  alias Riot.Api

  def for(%{"gameId" => id}) do
    id
    |> Api.match()
    |> process_into_struct()
  end

  defp process_into_struct({:ok, %{"gameId" => id, "participantIdentities" => players}}) do
    %__MODULE__{id: id, players: Enum.map(players, &Riot.Player.for/1)}
  end

  defp process_into_struct({:error, _}), do: %__MODULE__{}
end
