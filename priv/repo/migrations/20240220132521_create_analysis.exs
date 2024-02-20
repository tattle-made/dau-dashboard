defmodule DAU.Repo.Migrations.CreateAnalysis do
  use Ecto.Migration

  def change do
    create table(:analysis) do
      add :content, :map

      timestamps(type: :utc_datetime)
    end
  end
end
