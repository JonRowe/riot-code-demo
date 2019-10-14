defmodule RiotTest do
  use Test.Support.RiotCase, async: false

  import ExUnit.CaptureLog

  doctest Riot

  describe "find_recent_played_with_matches(name)" do
    setup %{bypass: bypass} do
      expect_http(bypass, "/lol/summoner/v4/summoners/by-name/LordTest", "lord_test.json")
      expect_http(bypass, "/lol/match/v4/matchlists/by-account/ccccddddd", "match_list_2.json")
      expect_http(bypass, "/lol/match/v4/matchlists/by-account/aaa", "empty_match_list.json")
      expect_http(bypass, "/lol/match/v4/matchlists/by-account/bbb", "empty_match_list.json")
      expect_http(bypass, "/lol/match/v4/matchlists/by-account/ccc", "empty_match_list.json")
      expect_http(bypass, "/lol/match/v4/matches/222", "match_2.json")
      expect_http(bypass, "/lol/match/v4/matches/333", "match_3.json")
    end

    test "it will print recent matches" do
      log =
        capture_log([colors: [enabled: false]], fn ->
          Riot.find_recent_played_with_matches("LordTest")
        end)

      assert log =~
               "Last 5 matches for: LordTest\n" <>
                 "\n" <>
                 "Match: 222\n" <>
                 "\n" <>
                 "Players:\n" <>
                 "OpponentA\n" <>
                 "OpponentB\n" <>
                 "\n" <>
                 "Match: 333\n" <>
                 "\n" <>
                 "Players:\n" <>
                 "OpponentB\n" <>
                 "OpponentC\n"
    end

    test "it will check for new matches", %{bypass: bypass} do
      # ensure we'll have longer checks
      mutate_config(:interval, 50)

      Riot.find_recent_played_with_matches("LordTest")

      # change stub to allow matches to be added
      expect_http(bypass, "/lol/match/v4/matchlists/by-account/aaa", "match_list_2.json")

      # sleep long enough to capture annoucement
      log = capture_log([colors: [enabled: false]], fn -> Process.sleep(100) end)

      assert log =~ "Player OpponentA has new matches 222, 333"
    end
  end
end
