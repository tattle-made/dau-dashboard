defmodule DAU.Repo.Migrations.AddTagsTable do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :name, :string
      add :slug, :string
      add :tags_category_id, references(:tags_categories)
      timestamps(type: :utc_datetime)
    end

    create unique_index(:tags, [:slug])
  end
end
