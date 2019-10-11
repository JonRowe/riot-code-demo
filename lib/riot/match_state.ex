defmodule Riot.MatchState do
  defstruct name: "", matches: []

  alias Riot.{Api, MatchInfo}

  def for_player(name) do
    name
    |> find_account()
    |> find_matches()
    |> process_into_struct()
  end

  defp find_account(name) do
    Api.summoner_by_name(name)
  end

  defp find_matches({:ok, account = %{"accountId" => id}}) do
    {Api.match_lists_by_account(id), account}
  end

  defp find_matches(_), do: {:error, "No account found"}

  defp process_into_struct({{:ok, %{"matches" => matches}}, %{"name" => name}}) do
    %__MODULE__{name: name, matches: Enum.map(matches, &MatchInfo.for/1)}
  end

  defp process_into_struct({{:error, _}}), do: {:error, "Error finding matches"}

  defp process_into_struct({:error, msg}), do: {:error, msg}

  defp process_into_struct(_), do: {:error, "Error creating match list"}
end
