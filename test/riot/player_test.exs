defmodule Riot.PlayerTest do
  use Test.Support.RiotCase, async: false

  alias Riot.{Api, Player}

  describe "for(match)" do
    setup %{bypass: bypass} do
      expect_http(bypass, "/lol/match/v4/matches/123456789", "match_1.json")
      {:ok, %{"participantIdentities" => [player]}} = Api.match("123456789")

      {:ok, player: player}
    end

    test "it returns player info", %{player: player} do
      assert Player.for(player) == %Player{id: "aaaabbbb", name: "OpponentA"}
    end
  end
end
