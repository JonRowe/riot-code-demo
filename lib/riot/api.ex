defmodule Riot.Api do
  def summoner_by_name(name) do
    get("/lol/summoner/v4/summoners/by-name/#{name}")
  end

  def match_lists_by_account(id) do
    get("/lol/match/v4/matchlists/by-account/#{id}")
  end

  def match(id) do
    get("/lol/match/v4/matches/#{id}")
  end

  defp endpoint("/" <> path) do
    env(:endpoint) <> path <> "?api_key=" <> env(:api_key)
  end

  defp env(name) do
    Application.get_env(:riot, name, "")
  end

  defp get(path) do
    case HTTPotion.get(endpoint(path)) do
      %HTTPotion.Response{status_code: 200, body: body} -> Jason.decode(body)
      _ -> {:error, "Failed to get #{path}"}
    end
  end
end
