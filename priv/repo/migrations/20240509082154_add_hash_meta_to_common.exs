defmodule DAU.Repo.Migrations.AddHashMetaToCommon do
  use Ecto.Migration

  def change do
    alter table(:feed_common) do
      add :hash_meta_id, references(:hash_meta, on_delete: :nothing)
    end
  end
end
