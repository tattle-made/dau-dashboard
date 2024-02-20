defmodule DAU.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :content, :map

      timestamps(type: :utc_datetime)
    end
  end
end
