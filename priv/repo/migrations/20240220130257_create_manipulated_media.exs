defmodule DAU.Repo.Migrations.CreateManipulatedMedia do
  use Ecto.Migration

  def change do
    create table(:manipulated_media) do
      add :description, :string
      add :url, :string

      timestamps(type: :utc_datetime)
    end
  end
end
