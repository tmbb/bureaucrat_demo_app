defmodule BureaucratDemoAppWeb.PageController do
  use BureaucratDemoAppWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
