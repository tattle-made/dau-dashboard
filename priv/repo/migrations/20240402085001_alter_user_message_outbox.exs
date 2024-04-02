defmodule DAU.Repo.Migrations.AlterUserMessageOutbox do
  use Ecto.Migration

  def change do
    alter table(:user_message_outbox) do
      modify :text, :text
      add :approved_by, references(:users)
    end
  end
end
