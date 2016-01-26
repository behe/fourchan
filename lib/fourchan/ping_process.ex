defmodule Fourchan.PingProcess do
  use GenServer

  require Logger

  def start_link() do
    GenServer.start_link(__MODULE__, [])
  end

  def init(_) do
    :timer.send_interval(1_000, :ping)
    {:ok, %{count: 0}}
  end

  def handle_info(:ping, %{count: count}) do
    count = count + 1
    Logger.debug "Got ping #{count}"
    Fourchan.Endpoint.broadcast!("messages:updates", "ping", %{count: count})
    {:noreply, %{count: count}}
  end
end
