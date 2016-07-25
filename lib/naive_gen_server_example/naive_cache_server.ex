defmodule NaiveGenServerExample.NaiveCacheServer do
  alias NaiveGenServerExample.NaiveGenServer
  
  @behaviour NaiveGenServer

  # NaiveCacheServer API

  def add(server_pid, key, value) do
    NaiveGenServer.cast(server_pid, {:add, key, value})
  end

  def remove(server_pid, key) do
    NaiveGenServer.call(server_pid, {:remove, key})
  end

  # NaiveGenServer callbacks

  def init([]) do
    {:ok, %{}}
  end

  # synchronously remove key-value pair from cache
  def handle_call({:remove, key}, _from, state) do
    value = Map.get(state, key, :not_found)

    if value != :not_found do
      updated_state = Map.delete(state, key)

      {:reply, {:ok, value}, updated_state}
    else
      {:reply, :error, state}
    end
  end

  # asynchronously add key-value pair
  def handle_cast({:add, key, value}, state) do
    updated_state = Map.put(state, key, value)

    {:noreply, updated_state}
  end

  # print cache (out-of-band debug message)
  def handle_info(:print, state) do
    IO.inspect(state)

    {:noreply, state}
  end
end
