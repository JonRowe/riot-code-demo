defmodule Riot.PlayerTest do
  use Test.Support.RiotCase, async: false

  alias Riot.{Api, Player}

  describe "for(match)" do
    setup %{bypass: bypass} do
      expect_http(bypass, "/lol/match/v4/matches/123456789", "match_1.json")
      {:ok, %{"participantIdentities" => [player]}} = Api.match("123456789")

      expect_http(bypass, "/lol/match/v4/matchlists/by-account/aaaabbbb", "match_list_2.json")

      {:ok, player: player}
    end

    test "it returns player info", %{player: player} do
      assert Player.for(player) == %Player{
               id: "aaaabbbb",
               name: "OpponentA",
               match_ids: [222, 333]
             }
    end
  end

  describe "update(Player)" do
    setup %{bypass: bypass} do
      expect_http(bypass, "/lol/match/v4/matchlists/by-account/aaaabbbb", "match_list_2.json")

      :ok
    end

    test "it updates player info with matches" do
      player = %Player{
        id: "aaaabbbb",
        name: "OpponentA",
        match_ids: []
      }

      assert Player.update(player) == %Player{player | match_ids: [222, 333]}
    end
  end
end
