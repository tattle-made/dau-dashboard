defmodule DAU.Repo.Migrations.ChangeForeignKeyInInbox do
  use Ecto.Migration

  def change do
    alter table(:user_message_inbox) do
      remove :query_id
    end
  end
end
