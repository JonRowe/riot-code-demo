defmodule Riot.MatchStateTest do
  use Test.Support.RiotCase, async: false

  alias Riot.{MatchInfo, MatchState, Player}

  describe "for_player(name)" do
    setup %{bypass: bypass} do
      expect_http(bypass, "/lol/summoner/v4/summoners/by-name/LordTest", "lord_test.json")
      expect_http(bypass, "/lol/match/v4/matchlists/by-account/ccccddddd", "match_list.json")
      expect_http(bypass, "/lol/match/v4/matches/123456789", "match_1.json")
    end

    test "it returns match state" do
      assert MatchState.for_player("LordTest") == %MatchState{
               name: "LordTest",
               matches: [%MatchInfo{id: 123_456_789, players: [%Player{}]}]
             }
    end
  end
end
