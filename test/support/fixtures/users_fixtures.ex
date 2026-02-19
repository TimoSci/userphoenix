defmodule Userphoenix.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Userphoenix.Users` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Userphoenix.Users.create_user()

    user
  end

  @doc """
  Generate a user with an access token. Returns `{user, raw_token}`.
  """
  def user_fixture_with_token(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Userphoenix.Users.create_user_with_token()

    {user, user.raw_token}
  end
end
