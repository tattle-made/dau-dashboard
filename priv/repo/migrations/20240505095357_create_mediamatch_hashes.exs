defmodule DAU.Repo.Migrations.CreateMediamatchHashes do
  use Ecto.Migration

  def change do
    create table(:hashes) do
      add :value, :string
      add :worker_version, :string
      add :user_language, :string
      add :inbox_id, references(:user_message_inbox, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:hashes, [:inbox_id])
    create index(:hashes, [:value, :user_language])
  end
end
