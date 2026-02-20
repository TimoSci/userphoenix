defmodule UserphoenixWeb.TokenControllerTest do
  use UserphoenixWeb.ConnCase

  import Userphoenix.UsersFixtures

  describe "GET /u/:token" do
    test "redirects to dashboard with valid token", %{conn: conn} do
      {user, raw_token} = user_fixture_with_token()

      conn = get(conn, ~p"/u/#{raw_token}")
      assert redirected_to(conn) == ~p"/user/#{user}/dashboard"
    end

    test "redirects to /access with invalid token", %{conn: conn} do
      conn = get(conn, ~p"/u/invalidtoken1234567890abcdef00")
      assert redirected_to(conn) == ~p"/access"
      assert Phoenix.Flash.get(conn.assigns.flash, :error) =~ "Invalid access token"
    end

    test "sets session on valid token", %{conn: conn} do
      {user, raw_token} = user_fixture_with_token()

      conn = get(conn, ~p"/u/#{raw_token}")
      conn = get(recycle(conn), ~p"/user/#{user}/dashboard")
      assert conn.status == 200
    end
  end
end
