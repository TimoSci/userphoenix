defmodule Userphoenix.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :token_hash, :string
    field :raw_token, :string, virtual: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  @doc false
  def registration_changeset(user, attrs) do
    raw_token = Base.encode16(:crypto.strong_rand_bytes(16), case: :lower)
    hash = :crypto.hash(:sha256, raw_token) |> Base.encode16(case: :lower)

    user
    |> changeset(attrs)
    |> put_change(:token_hash, hash)
    |> put_change(:raw_token, raw_token)
    |> unique_constraint(:token_hash)
  end
end
