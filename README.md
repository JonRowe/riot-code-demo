# Riot Code Test

An application which has one function call, `Riot.find_recent_played_with_matches(summoner_name)`.

It calls Riot Games Summoner api to find the last 5 matches for a summoner, and from those matches
it will print a list of players, their matches and their summoner info. It will then monitor those
players for new matches and print any new matches that occur.

* https://developer.riotgames.com/api-methods/#summoner-v4
* https://developer.riotgames.com/api-methods/#match-v4
