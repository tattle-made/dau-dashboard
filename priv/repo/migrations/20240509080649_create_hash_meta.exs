defmodule DAU.Repo.Migrations.CreateHashMeta do
  use Ecto.Migration

  def change do
    create table(:hash_meta) do
      add :count, :integer, default: 0
      add :label, :string, size: 15
      add :description, :string
      add :value, :string
      add :user_language, :string

      timestamps(type: :utc_datetime)
    end
  end
end
