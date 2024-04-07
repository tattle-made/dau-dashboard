defmodule DAU.Repo.Migrations.AddNewQueryIdToInboxMessage do
  use Ecto.Migration

  def change do
    alter table(:user_message_inbox) do
      add :query_id, references(:user_message_query)
    end
  end
end
