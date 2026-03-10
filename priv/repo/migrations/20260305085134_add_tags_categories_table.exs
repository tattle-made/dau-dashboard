defmodule DAU.Repo.Migrations.AddTagsCategoriesTable do
  use Ecto.Migration

  def change do
    create table(:tags_categories) do
      add :category, :string, null: false
      add :slug, :string, null: false
      timestamps(type: :utc_datetime)
    end

    create unique_index(:tags_categories, [:slug])
  end
end
