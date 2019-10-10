defmodule Riot.Timer do
  def send(pid, message) do
    for i <- [1, 2, 3, 4, 5] do
      Process.send_after(pid, message, i * Application.get_env(:riot, :interval))
    end
  end
end
