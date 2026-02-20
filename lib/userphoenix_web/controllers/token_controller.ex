defmodule UserphoenixWeb.TokenController do
  use UserphoenixWeb, :controller

  alias Userphoenix.Users
  alias Userphoenix.RateLimiter

  def verify(conn, %{"token" => raw_token}) do
    case Users.get_user_by_token(raw_token) do
      {:ok, user} ->
        conn =
          conn
          |> put_session(:user_id, user.id)
          |> put_session(:token, raw_token)
          |> configure_session(renew: true)

        if Phoenix.Flash.get(conn.assigns.flash, :mnemonic) do
          render(conn, :welcome, user: user, token: raw_token)
        else
          redirect(conn, to: ~p"/user/#{user}/dashboard")
        end

      {:error, :not_found} ->
        ip = conn.remote_ip |> :inet.ntoa() |> to_string()
        RateLimiter.record_failure(ip)

        conn
        |> put_flash(:error, "Invalid access token.")
        |> redirect(to: ~p"/access/token")
    end
  end
end
