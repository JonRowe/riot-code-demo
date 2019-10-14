defmodule Riot.MatchInfoTest do
  use Test.Support.RiotCase, async: false

  alias Riot.{Api, MatchInfo, Player}

  describe "for(match)" do
    setup %{bypass: bypass} do
      expect_http(bypass, "/lol/match/v4/matchlists/by-account/ccccddddd", "match_list.json")
      {:ok, %{"matches" => [match]}} = Api.match_lists_by_account("ccccddddd")

      expect_http(bypass, "/lol/match/v4/matches/123456789", "match_1.json")
      {:ok, match: match}
    end

    test "it returns match info", %{match: match} do
      assert MatchInfo.for(match) == %MatchInfo{
               id: 123_456_789,
               players: [%Player{id: "aaaabbbb", name: "OpponentA"}]
             }
    end
  end
end
