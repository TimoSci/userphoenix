defmodule UserphoenixWeb.SettingsControllerTest do
  use UserphoenixWeb.ConnCase

  import Userphoenix.UsersFixtures

  setup do
    {user, token} = user_fixture_with_token()
    %{user: user, token: token}
  end

  describe "GET /user/:id/settings" do
    test "renders settings for authenticated user", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user) |> get(~p"/user/#{user}/settings")
      assert html_response(conn, 200) =~ "Settings"
      assert html_response(conn, 200) =~ "Nickname"
    end

    test "redirects to /access when not authenticated", %{conn: conn, user: user} do
      conn = get(conn, ~p"/user/#{user}/settings")
      assert redirected_to(conn) == "/access"
    end
  end

  describe "PUT /user/:id/settings" do
    test "updates the user name", %{conn: conn, user: user} do
      conn =
        conn
        |> log_in_user(user)
        |> put(~p"/user/#{user}/settings", %{"user" => %{"name" => "New Name"}})

      assert redirected_to(conn) == ~p"/user/#{user}/settings"
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Settings updated"
    end

    test "re-renders on invalid data", %{conn: conn, user: user} do
      conn =
        conn
        |> log_in_user(user)
        |> put(~p"/user/#{user}/settings", %{"user" => %{"name" => ""}})

      assert html_response(conn, 200) =~ "Settings"
    end
  end

  describe "DELETE /user/:id/settings" do
    test "deletes the account and redirects to home", %{conn: conn, user: user} do
      conn =
        conn
        |> log_in_user(user)
        |> delete(~p"/user/#{user}/settings")

      assert redirected_to(conn) == ~p"/"
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Account deleted"
    end
  end
end
