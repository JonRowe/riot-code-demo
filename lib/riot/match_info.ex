defmodule Riot.MatchInfo do
  defstruct id: nil, players: []

  def for(_match) do
    %__MODULE__{}
  end
end
