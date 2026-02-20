defmodule UserphoenixWeb.PageController do
  use UserphoenixWeb, :controller

  alias Userphoenix.Users

  def home(conn, _params) do
    render(conn, :home)
  end

  def logout(conn, _params) do
    conn
    |> clear_session()
    |> redirect(to: ~p"/")
  end

  def create(conn, _params) do
    case Users.create_user_with_token(%{name: "Anonymous"}) do
      {:ok, user} ->
        conn
        |> redirect(to: ~p"/u/#{user.raw_token}")

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Could not create account.")
        |> redirect(to: ~p"/")
    end
  end
end
