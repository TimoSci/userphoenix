defmodule UserphoenixWeb.PageControllerTest do
  use UserphoenixWeb.ConnCase

  test "GET / renders the home page with dashboard and create button", %{conn: conn} do
    conn = get(conn, ~p"/")
    html = html_response(conn, 200)
    assert html =~ "App Dashboard"
    assert html =~ "Create Anonymous Account"
  end

  test "POST / creates an anonymous user and redirects to /u/:token", %{conn: conn} do
    conn = post(conn, ~p"/")
    assert "/u/" <> _token = redirected_to(conn)
  end

  test "POST / sets up a valid token URL that redirects to user dashboard", %{conn: conn} do
    conn = post(conn, ~p"/")
    redirect_path = redirected_to(conn)

    conn = get(recycle(conn), redirect_path)
    assert "/user/" <> _rest = redirected_to(conn)
  end
end
