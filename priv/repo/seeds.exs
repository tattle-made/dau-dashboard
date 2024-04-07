# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     DAU.Repo.insert!(%DAU.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias DAU.Feed.Common
alias DAU.Repo
alias DAU.Accounts.User
alias DAU.Accounts

# Create Users
[
  %{email: "dau_admin@email.com", password: "dau_admin_pw", role: :admin},
  %{
    email: "dau_associate2@email.com",
    password: "dau_associate_pw",
    role: :secratariat_associate
  },
  %{
    email: "tattle_manager@email.com",
    password: "tattle_manager_pw",
    role: :secratariat_manager
  },
  %{
    email: "dau_factchecker@email.com",
    password: "dau_factchecker_pw",
    role: :expert_factchecker
  },
  %{
    email: "dau_forensic@email.com",
    password: "dau_forensic_pw",
    role: :expert_forensic
  },
  %{email: "dau_user@email.com", password: "dau_user_pw", role: :user}
]
|> Enum.map(&Accounts.register_user(&1))
