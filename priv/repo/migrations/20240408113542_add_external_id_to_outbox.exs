defmodule DAU.Repo.Migrations.AddExternalIdToOutbox do
  use Ecto.Migration

  def change do
    alter table(:user_message_outbox) do
      add :e_id, :string
    end
  end
end
