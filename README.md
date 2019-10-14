# Riot Code Test

An application which has one function call, `Riot.find_recent_played_with_matches(summoner_name)`.

It calls Riot Games Summoner api to find the last 5 matches for a summoner, and from those matches
it will print a list of players, their matches and their summoner info. It will then monitor those
players for new matches and print any new matches that occur.

See:

* https://developer.riotgames.com/api-methods/#summoner-v4
* https://developer.riotgames.com/api-methods/#match-v4

Downides to this implementation:

It requires running within a process such as via the tests or iex, as the gen server binds to the
current running process, really it should be supverised and have a bit more control around it.

Developed without testing against the real API as I couldn't get credentials so all the JSON is
simulated.

Has a override file for part of bypass due to a missing functionality that is only needed for one test,
am going to open a PR with bypass about it.
