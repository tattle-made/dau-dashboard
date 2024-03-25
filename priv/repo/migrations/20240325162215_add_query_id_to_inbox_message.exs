defmodule DAU.Repo.Migrations.AddQueryIdToInboxMessage do
  use Ecto.Migration

  def change do
    alter table(:user_message_inbox) do
      add :query_id, references(:feed_common)
    end
  end
end
