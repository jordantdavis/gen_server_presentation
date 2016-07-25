defmodule GenServerInitExample.ServerWithLengthyInit do
  use GenServer

  def init([]) do
    send(self, :initialize)

    {:ok, %{"ready" => false}}
  end

  def handle_call(:ready, _from, %{"ready" => false} = state) do
    {:reply, :no, state}
  end

  def handle_call(:ready, _from, %{"ready" => true} = state) do
    {:reply, :yes, state}
  end

  def handle_info(:initialize, state) do
    IO.inspect("Performing further initialization...")

    :timer.sleep(1000)

    updated_state = %{state | "ready" => true}

    :timer.sleep(1000)

    IO.inspect("Initialization complete.")

    {:noreply, updated_state}
  end

  def handle_info(_message, state) do
    {:noreply, state}
  end
end
