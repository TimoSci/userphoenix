defmodule UserphoenixWeb.DashboardControllerTest do
  use UserphoenixWeb.ConnCase

  import Userphoenix.UsersFixtures

  setup do
    {user, token} = user_fixture_with_token()
    %{user: user, token: token}
  end

  test "GET /u/:token/dashboard renders the dashboard", %{conn: conn, user: user, token: token} do
    conn = get(conn, ~p"/u/#{token}/dashboard")
    assert html_response(conn, 200) =~ "Dashboard"
    assert html_response(conn, 200) =~ user.name
  end

  test "GET /u/:token/dashboard redirects to /access with invalid token", %{conn: conn} do
    conn = get(conn, ~p"/u/invalidtoken1234567890abcdef00/dashboard")
    assert redirected_to(conn) == ~p"/access"
    assert Phoenix.Flash.get(conn.assigns.flash, :error) =~ "Invalid access token"
  end
end
