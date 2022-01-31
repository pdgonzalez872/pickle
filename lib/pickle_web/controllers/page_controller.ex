defmodule PickleWeb.PageController do
  use PickleWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
