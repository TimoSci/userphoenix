defmodule UserphoenixWeb.SettingsController do
  use UserphoenixWeb, :controller

  alias Userphoenix.Users
  alias Userphoenix.Users.Mnemonic

  def show(conn, _params) do
    user = conn.assigns.current_user
    changeset = Users.change_user(user)
    token = get_session(conn, :token)
    mnemonic = if token, do: Mnemonic.encode(token)
    render(conn, :show, user: user, changeset: changeset, mnemonic: mnemonic)
  end

  def update(conn, %{"user" => user_params}) do
    user = conn.assigns.current_user

    case Users.update_user(user, user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Settings updated.")
        |> redirect(to: ~p"/user/#{user}/settings")

      {:error, changeset} ->
        token = get_session(conn, :token)
        mnemonic = if token, do: Mnemonic.encode(token)
        render(conn, :show, user: user, changeset: changeset, mnemonic: mnemonic)
    end
  end

  def delete(conn, _params) do
    user = conn.assigns.current_user
    {:ok, _user} = Users.delete_user(user)

    conn
    |> clear_session()
    |> put_flash(:info, "Account deleted.")
    |> redirect(to: ~p"/")
  end
end
