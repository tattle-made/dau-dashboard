defmodule DAU.Repo.Migrations.CreateResponse do
  use Ecto.Migration

  def change do
    create table(:responses) do
      add :content, :map

      timestamps(type: :utc_datetime)
    end
  end
end
