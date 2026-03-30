defmodule Scripts.ConfirmExistingUsersEmail do
  alias DAU.Repo
  alias DAU.Accounts.User
  import Ecto.Query, only: [from: 2]

  def run() do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    {count, _} =
      from(u in User, where: is_nil(u.confirmed_at))
      |> Repo.update_all(set: [confirmed_at: now])

    IO.puts("Confirmed #{count} user(s).")
  end
end
