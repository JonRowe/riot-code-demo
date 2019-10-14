defmodule Riot.Server do
  use GenServer

  alias Riot.Player

  require Logger

  def watch(players) do
    GenServer.start_link(__MODULE__, players)
  end

  def init(players) do
    {:ok, [players: players]}
  end

  def handle_call(message, _from, state) do
    new_state = perform(message, state)
    {:reply, new_state, new_state}
  end

  def handle_info(:check, state) do
    new_state = perform(:check, state)
    {:noreply, new_state}
  end

  def handle_cast(message, state) do
    new_state = perform(message, state)
    {:noreply, new_state}
  end

  defp perform(:check, players: players) do
    [players: Enum.map(players, &update_player/1)]
  end

  defp perform(_, state) do
    state
  end

  defp update_player(player = %Player{match_ids: old_ids}) do
    updated_player = %Player{match_ids: new_ids} = Player.update(player)
    announce_ids(player, old_ids, new_ids)
    updated_player
  end

  # no op
  defp announce_ids(_, ids, ids), do: :ok

  defp announce_ids(player, old_ids, new_ids) do
    delta_ids = new_ids -- old_ids
    Logger.info("Player #{player.name} has new matches #{Enum.join(delta_ids, ", ")}")
    :ok
  end
end
