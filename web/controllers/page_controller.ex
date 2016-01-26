defmodule Fourchan.PageController do
  use Fourchan.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def ping(conn, _params) do
    Fourchan.Endpoint.broadcast!("messages:updates", "ping", %{})
    send_resp(conn, 200, "")
  end
end
