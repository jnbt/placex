defmodule Placex.PageController do
  use Placex.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
