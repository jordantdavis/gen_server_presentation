defmodule NaiveGenServerExample.NaiveGenServer do
  # behaviour callback specs
  @callback init(args :: list(any)) ::
    {:ok, state :: any}

  @callback handle_call(request :: any, from :: pid, state :: any) ::
    {:reply, response :: any, state :: any}

  @callback handle_cast(request :: any, state :: any) ::
    {:noreply, state :: any}

  @callback handle_info(request :: any, state :: any) ::
    {:noreply, state :: any}

  # spawn a new NaiveGenServer process
  def start(callback_module, args \\ []) do
    server_pid = spawn(fn ->
      # init callback
      {:ok, initial_state} = callback_module.init(args)

      # loop forever
      loop(callback_module, initial_state)
    end)

    {:ok, server_pid}
  end

  # synchronous call to server
  def call(server_pid, message) do
    # send message
    send(server_pid, {:call, message, self})

    # await response
    receive do
      {:response, response} ->
        response
      after 5000 ->
        :timeout
    end
  end

  # asynchronous call to server
  def cast(server_pid, message) do
     send(server_pid, {:cast, message})

     :ok
   end

   # message receive loop
  defp loop(callback_module, current_state) do
    updated_state = receive do
      # handle_call
      {:call, message, caller} ->
        {response, updated_state} =
          do_handle_call(callback_module, message, caller, current_state)

        send(caller, {:response, response})

        updated_state

      # handle_cast
      {:cast, message} ->
        do_handle_cast(callback_module, message, current_state)

      # handle_info
      message ->
        do_handle_info(callback_module, message, current_state)
    end

    loop(callback_module, updated_state)
  end

  defp do_handle_call(callback_module, message, caller, current_state) do
    # handle_call callback
    {:reply, response, updated_state} =
      callback_module.handle_call(message, caller, current_state)

    {response, updated_state}
  end

  defp do_handle_cast(callback_module, message, current_state) do
    # handle_cast callback
    {:noreply, updated_state} =
      callback_module.handle_cast(message, current_state)

    updated_state
  end

  defp do_handle_info(callback_module, message, current_state) do
    # handle_info callback
    {:noreply, updated_state} =
      callback_module.handle_info(message, current_state)

    updated_state
  end
end
