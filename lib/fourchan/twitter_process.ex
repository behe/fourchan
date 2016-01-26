defmodule Fourchan.TwitterProcess do
  use GenServer

  require Logger

  def watch(keyword, pid) do
    IO.puts "watch #{keyword}"
    GenServer.cast(__MODULE__, {:watch, keyword, pid})
  end

  # GenServer API

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    {:ok, %{watchers: []}}
  end

  def handle_cast({:watch, keyword, pid}, state) do
    spawn(fn ->
      for tweet <- ExTwitter.stream_filter(track: keyword, timeout: 3_600_000) do
        send pid, {:new_msg, tweet}
        # Fourchan.Endpoint.broadcast!("messages:updates", "new_msg", %{
        #   body: "tweet.text"
        # })
      end
    end)

    {:noreply, put_in(state, [:watchers], %{keyword: keyword, pid: pid})}
  end
end
