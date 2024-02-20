defmodule DAU.Repo do
  use Ecto.Repo,
    otp_app: :dau,
    adapter: Ecto.Adapters.Postgres
end
