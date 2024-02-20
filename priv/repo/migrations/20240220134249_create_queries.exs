defmodule DAU.Repo.Migrations.CreateQueries do
  use Ecto.Migration

  def change do
    create table(:queries) do
      add :messages, {:array, :string}
      add :status, :string
      add :response, references(:responses, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:queries, [:response])
  end
end
