defmodule Riot.ApiTest do
  use Test.Support.RiotCase, async: true

  alias Riot.Api

  describe "summoner_by_name(name)" do
    test "it invokes the api /lol/summoner/v4/summoners/by-name/", %{bypass: bypass} do
      expect_http(bypass, "/lol/summoner/v4/summoners/by-name/LordTest", "lord_test.json")

      assert Api.summoner_by_name("LordTest") ==
               {:ok,
                %{
                  "accountId" => "ccccddddd",
                  "id" => "aaaabbbbb",
                  "name" => "LordTest",
                  "profileIconId" => 100,
                  "puuid" => "aaaa1111",
                  "revisionDate" => "",
                  "summonerLevel" => 10
                }}
    end
  end

  describe "match_lists_by_account(id)" do
    test "it invokes the api /lol/match/v4/matchlists/by-account/", %{bypass: bypass} do
      expect_http(bypass, "/lol/match/v4/matchlists/by-account/aaaabbbb", "match_list.json")

      assert Api.match_lists_by_account("aaaabbbb") ==
               {:ok,
                %{
                  "matches" => [
                    %{
                      "champion" => 123_456_789,
                      "gameId" => 123_456_789,
                      "lane" => "",
                      "platformId" => "platform_a",
                      "queue" => 0,
                      "role" => "dev",
                      "season" => 0,
                      "timestamp" => 123_456_789
                    }
                  ],
                  "endIndex" => 0,
                  "startIndex" => 0,
                  "totalGames" => 1
                }}
    end
  end

  describe "match(id)" do
    test "it invokes the api GET /lol/match/v4/matches/", %{bypass: bypass} do
      expect_http(bypass, "/lol/match/v4/matches/123456789", "match_1.json")

      assert Api.match("123456789") ==
               {:ok,
                %{
                  "gameCreation" => 123_456_789,
                  "gameDuration" => 123_456_789,
                  "gameId" => 123_456_789,
                  "gameMode" => "",
                  "gameType" => "",
                  "gameVersion" => "",
                  "mapId" => 123_456_789,
                  "participantIdentities" => [
                    %{
                      "participantId" => 123_456_789,
                      "player" => %{
                        "accountId" => "",
                        "currentAccountId" => "aaaabbbb",
                        "currentPlatformId" => "",
                        "matchHistoryUri" => "",
                        "platformId" => "",
                        "profileIcon" => 123_456_789,
                        "summonerId" => "",
                        "summonerName" => "OpponentA"
                      }
                    }
                  ],
                  "participants" => [],
                  "platformId" => "",
                  "queueId" => 123_456_789,
                  "seasonId" => 123_456_789,
                  "teams" => []
                }}
    end
  end
end
