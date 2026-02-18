defmodule Userphoenix.Repo do
  use Ecto.Repo,
    otp_app: :userphoenix,
    adapter: Ecto.Adapters.Postgres
end
