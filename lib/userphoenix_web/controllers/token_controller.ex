defmodule UserphoenixWeb.TokenController do
  use UserphoenixWeb, :controller

  alias Userphoenix.Users
  alias Userphoenix.RateLimiter

  def verify(conn, %{"token" => raw_token}) do
    case Users.get_user_by_token(raw_token) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
        |> redirect(to: ~p"/users/#{user}")

      {:error, :not_found} ->
        ip = conn.remote_ip |> :inet.ntoa() |> to_string()
        RateLimiter.record_failure(ip)

        conn
        |> put_flash(:error, "Invalid access token.")
        |> redirect(to: ~p"/access")
    end
  end
end
