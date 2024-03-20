defmodule DAU.Release do
  @moduledoc """
  Used for executing DB release tasks when run in production without Mix
  installed.
  """
  alias DAU.Accounts
  @app :dau

  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  def register_user(email, password, role) do
    load_app()

    case Accounts.register_user(%{email: email, password: password, role: role}) do
      {:ok, user} -> IO.inspect(user)
      {:error, %Ecto.Changeset{} = changeset} -> IO.inspect(changeset)
    end
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
  end
end
