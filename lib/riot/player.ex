defmodule Riot.Player do
  defstruct id: "", name: ""

  def for(%{"player" => %{"currentAccountId" => id, "summonerName" => name}}) do
    %__MODULE__{id: id, name: name}
  end

  def for(_), do: %__MODULE__{}
end
