defmodule OnlineBankingWeb.PageController do
  use OnlineBankingWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
