defmodule GenServerInitExample.ServerWithLengthyInit do
  use GenServer

  def init([]) do
    send(self, :initialize)

    {:ok, %{"ready" => false}}
  end

  def handle_info(:initialize, state) do
    IO.inspect("Performing further initialization...")

    :timer.sleep(3000)

    IO.inspect("Initialization complete.")

    {:noreply, state}
  end

  def handle_info(_message, state) do
    {:noreply, state}
  end
end
