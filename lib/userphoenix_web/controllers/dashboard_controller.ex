defmodule UserphoenixWeb.DashboardController do
  use UserphoenixWeb, :controller

  alias Userphoenix.Users
  alias Userphoenix.RateLimiter

  def show(conn, %{"token" => raw_token}) do
    case Users.get_user_by_token(raw_token) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
        |> render(:show, user: user, token: raw_token)

      {:error, :not_found} ->
        ip = conn.remote_ip |> :inet.ntoa() |> to_string()
        RateLimiter.record_failure(ip)

        conn
        |> put_flash(:error, "Invalid access token.")
        |> redirect(to: ~p"/access")
    end
  end
end
