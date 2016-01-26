defmodule Fourchan.MessageChannel do
  use Fourchan.Web, :channel

  intercept ["ping"]

  def join("messages:updates", _params, socket) do
    {:ok, socket}
  end

  def handle_in("subscribe", %{"topic" => topic}, socket) do
    {:ok, agent} = Agent.start_link(fn ->
      ExTwitter.search(topic, count: 100)
    end)
    Fourchan.TwitterProcess.watch(topic, self)
    :timer.send_interval(1_000, :update)
    {:reply, :ok, assign(socket, :agent, agent)}
  end

  def handle_out("ping", %{count: count}, socket) do
    # count = (socket.assigns[:count] || 0) + 1
    push socket, "ping", %{count: count}

    {:noreply, assign(socket, :count, count)}
  end

  def handle_info({:new_msg, tweet}, socket) do
    IO.puts "IN: #{tweet.text}"
    Agent.update(socket.assigns[:agent], fn(tweets) ->
      [tweet | tweets]
    end)
    {:noreply, socket}
  end

  def handle_info(:update, socket) do
    tweet = Agent.get_and_update(socket.assigns[:agent], fn([tweet | tweets]) ->
      {tweet, tweets}
    end)
    IO.puts "OUT: #{tweet.text}"
    push socket, "tweet", %{text: tweet.text}
    {:noreply, socket}
  end
end
