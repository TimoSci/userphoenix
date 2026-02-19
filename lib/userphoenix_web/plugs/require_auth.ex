defmodule UserphoenixWeb.Plugs.RequireAuth do
  @moduledoc """
  Plug that redirects unauthenticated users to /access.
  """

  import Plug.Conn
  import Phoenix.Controller, only: [redirect: 2]

  def init(opts), do: opts

  def call(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> redirect(to: "/access")
      |> halt()
    end
  end
end
