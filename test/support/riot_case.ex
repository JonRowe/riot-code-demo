defmodule Test.Support.RiotCase do
  @moduledoc """
  This module defines the setup for tests.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      import Test.Support.RiotCase
    end
  end

  setup do
    bypass = Bypass.open()
    mutate_config(:endpoint, "http://localhost:#{bypass.port}/")
    mutate_config(:api_key, "T0K3N")
    {:ok, bypass: bypass}
  end

  def mutate_config(name, value) do
    original = Application.get_env(:riot, name)

    on_exit(fn ->
      Application.get_env(:riot, name, original)
    end)

    Application.put_env(:riot, name, value)
  end
end
