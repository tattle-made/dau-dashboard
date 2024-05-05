defmodule DAU.Repo.Migrations.CreateMediamatchHashes do
  use Ecto.Migration

  def change do
    create table(:mediamatch_hashes) do
      add :value, :string
      add :worker_version, :string
      add :inbox_id, references(:user_message_inbox, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:mediamatch_hashes, [:inbox_id])
    create index(:mediamatch_hashes, [:value])
  end
end
