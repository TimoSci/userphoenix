defmodule UserphoenixWeb.PageController do
  use UserphoenixWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
