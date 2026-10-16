defmodule DAU.Repo.Migrations.ChangeHashValuesToText do
  use Ecto.Migration

  def change do
    alter table(:hashes) do
      modify :value, :text, from: :string
    end

    alter table(:hash_meta) do
      modify :value, :text, from: :string
    end
  end
end
