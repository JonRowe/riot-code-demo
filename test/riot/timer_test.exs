defmodule Riot.TimerTest do
  use ExUnit.Case, async: true

  alias Riot.Timer

  describe "send(pid, message)" do
    # Configure a longer interval to test the counter, whilst retaining
    # the short 1ms interval for potential other tests.
    setup do
      original = Application.get_env(:riot, :interval)

      on_exit(fn ->
        Application.get_env(:riot, :interval, original)
      end)

      Application.put_env(:riot, :interval, 50)

      :ok
    end

    test "it will send 5 messages at interval" do
      Timer.send(self(), :message)

      # Introduce a slight delay as jitter
      Process.sleep(5)

      # Then we should receive 5 messages 50ms
      assert_receive :message, 50
      assert_receive :message, 50
      assert_receive :message, 50
      assert_receive :message, 50
      assert_receive :message, 50

      # no more are sent
      refute_receive :message, 50
    end
  end
end
