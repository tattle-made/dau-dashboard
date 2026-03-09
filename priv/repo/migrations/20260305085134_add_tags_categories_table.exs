defmodule DAU.Repo.Migrations.AddTagsCategoriesTable do
  use Ecto.Migration

  def change do
    create table(:tags_categories) do
      add :category, :string
      add :slug, :string
      timestamps(type: :utc_datetime)
    end
  end
end
