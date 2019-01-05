defmodule BloomWeb.PageController do
  use BloomWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
