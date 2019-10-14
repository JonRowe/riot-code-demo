defmodule Riot.ServerTest do
  use Test.Support.RiotCase, async: false

  import ExUnit.CaptureLog

  alias Riot.{Player, Server}

  describe "init/1" do
    test "it generates the default state" do
      assert Server.init([]) == {:ok, [players: []]}
    end
  end

  describe "handle_call/3" do
    test "it will update players matches", %{bypass: bypass} do
      {:ok, pid} = GenServer.start_link(Server, [%Player{id: "aaaabbbb"}])
      expect_http(bypass, "/lol/match/v4/matchlists/by-account/aaaabbbb", "match_list_2.json")

      assert GenServer.call(pid, :check) == [
               players: [%Player{id: "aaaabbbb", match_ids: [222, 333]}]
             ]
    end

    test "it will announce an updated players matches", %{bypass: bypass} do
      {:ok, pid} = GenServer.start_link(Server, [%Player{id: "aaaabbbb", name: "LordTest"}])
      expect_http(bypass, "/lol/match/v4/matchlists/by-account/aaaabbbb", "match_list_2.json")

      log = capture_log(fn -> GenServer.call(pid, :check) end)
      assert log =~ "Player LordTest has new matches 222, 333"
    end

    test "it will ignore players who haven't changed", %{bypass: bypass} do
      {:ok, pid} = GenServer.start_link(Server, [%Player{id: "aaaabbbb", match_ids: [222, 333]}])
      expect_http(bypass, "/lol/match/v4/matchlists/by-account/aaaabbbb", "match_list_2.json")

      log = capture_log(fn -> GenServer.call(pid, :check) end)
      assert log == ""
    end
  end

  describe "handle_cast/3" do
    test "it will update players matches", %{bypass: bypass} do
      {:ok, pid} = GenServer.start_link(Server, [%Player{id: "aaaabbbb"}])
      expect_http(bypass, "/lol/match/v4/matchlists/by-account/aaaabbbb", "match_list_2.json")
      GenServer.cast(pid, :check)
      GenServer.stop(pid)
    end

    test "it will announce an updated players matches", %{bypass: bypass} do
      {:ok, pid} = GenServer.start_link(Server, [%Player{id: "aaaabbbb", name: "LordTest"}])
      expect_http(bypass, "/lol/match/v4/matchlists/by-account/aaaabbbb", "match_list_2.json")

      log =
        capture_log(fn ->
          GenServer.cast(pid, :check)
          GenServer.stop(pid)
        end)

      assert log =~ "Player LordTest has new matches 222, 333"
    end

    test "it will ignore players who haven't changed", %{bypass: bypass} do
      {:ok, pid} = GenServer.start_link(Server, [%Player{id: "aaaabbbb", match_ids: [222, 333]}])
      expect_http(bypass, "/lol/match/v4/matchlists/by-account/aaaabbbb", "match_list_2.json")

      log =
        capture_log(fn ->
          GenServer.cast(pid, :check)
          GenServer.stop(pid)
        end)

      assert log == ""
    end
  end
end
