defmodule DAU.Repo.Migrations.AddCommonTagsTable do
  use Ecto.Migration

  def change do
    create table(:common_tags) do
      add :common_id, references(:feed_common, on_delete: :delete_all), null: false
      add :tag_id, references(:tags, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:common_tags, [:common_id, :tag_id], name: :common_tags_unique_index)
  end
end
