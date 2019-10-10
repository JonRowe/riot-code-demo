defmodule Riot.ApiTest do
  use Test.Support.RiotCase, async: true

  alias Riot.Api

  setup do
    bypass = Bypass.open()
    mutate_config(:endpoint, "http://localhost:#{bypass.port}/")
    mutate_config(:api_key, "T0K3N")
    {:ok, bypass: bypass}
  end

  describe "summoner_by_name(name)" do
    test "it invokes the api /lol/summoner/v4/summoners/by-name/", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        assert "/lol/summoner/v4/summoners/by-name/LordTest" == conn.request_path
        assert %{"api_key" => "T0K3N"} == Plug.Conn.fetch_query_params(conn).query_params
        assert "GET" == conn.method
        Plug.Conn.resp(conn, 200, String.replace(~s<{
          "profileIconId": 100, # ID of the summoner icon associated with the summoner.
          "name": "LordTest", #  Summoner name.
          "puuid": "aaaa1111", # Encrypted PUUID. Exact length of 78 characters.
          "summonerLevel": 10, # Summoner level associated with the summoner.
          "revisionDate": "", # Date summoner was last modified specified as epoch milliseconds.
          "id": "aaaabbbbb", #  Encrypted summoner ID. Max length 63 characters.
          "accountId": "ccccddddd" #  Encrypted account ID. Max length 56 characters.
        }>, ~r{\s+#.*}, ""))
      end)

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
      Bypass.expect(bypass, fn conn ->
        assert "/lol/match/v4/matchlists/by-account/aaaabbbb" == conn.request_path
        assert %{"api_key" => "T0K3N"} == Plug.Conn.fetch_query_params(conn).query_params
        assert "GET" == conn.method
        Plug.Conn.resp(conn, 200, String.replace(~s<{
          "matches": # A list of matches
             [
               {
                 "lane": "",
                 "gameId": 123456789,
                 "champion": 123456789,
                 "platformId": "platform_a",
                 "season": 0,
                 "queue": 0,
                 "role": "dev",
                 "timestamp": 123456789
              }
             ],
          "totalGames": 1,
          "startIndex": 0,
          "endIndex": 0
        }>, ~r{\s+#.*}, ""))
      end)

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
      Bypass.expect(bypass, fn conn ->
        assert "/lol/match/v4/matches/123456789" == conn.request_path
        assert %{"api_key" => "T0K3N"} == Plug.Conn.fetch_query_params(conn).query_params
        assert "GET" == conn.method
        Plug.Conn.resp(conn, 200, String.replace(~s<{
          "seasonId": 123456789, # Please refer to the Game Constants documentation.
          "queueId": 123456789, # Please refer to the Game Constants documentation.
          "gameId": 123456789,
          "participantIdentities": [ # Participant identity information.
             { "player": {
               },
               "participantId": 123456789
             }
          ],
          "gameVersion": "", # The major.minor version typically indicates the patch the match was played on.
          "platformId": "", # Platform where the match was played.
          "gameMode": "", # Please refer to the Game Constants documentation.
          "mapId": 123456789, # Please refer to the Game Constants documentation.
          "gameType": "", # Please refer to the Game Constants documentation.
          "teams": [ # Team information.
            # TeamStatsDto
          ],
          "participants": [ # Participant information.
            # ParticipantDto
          ],
          "gameDuration": 123456789, # Match duration in seconds.
          "gameCreation": 123456789 # Designates the timestamp when champion select ended and the loading screen appeared, NOT when the game timer was at 0:00.
        }>, ~r{\s+#.*}, ""))
      end)

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
                  "participantIdentities" => [%{"participantId" => 123_456_789, "player" => %{}}],
                  "participants" => [],
                  "platformId" => "",
                  "queueId" => 123_456_789,
                  "seasonId" => 123_456_789,
                  "teams" => []
                }}
    end
  end
end
