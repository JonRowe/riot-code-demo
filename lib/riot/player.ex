defmodule Riot.Player do
  defstruct id: "", name: "", match_ids: []

  alias Riot.Api

  def for(%{"player" => %{"currentAccountId" => id, "summonerName" => name}}), do: build(id, name)

  def for(_), do: %__MODULE__{}

  def update(%__MODULE__{id: id, name: name}), do: build(id, name)

  defp build(id, name) do
    {:ok, %{"matches" => matches}} = Api.match_lists_by_account(id)
    %__MODULE__{id: id, name: name, match_ids: Enum.map(matches, fn match -> match["gameId"] end)}
  end
end
