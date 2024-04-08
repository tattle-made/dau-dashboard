defmodule DAU.Repo.Migrations.AddContentIdToInbox do
  use Ecto.Migration

  def change do
    alter table(:user_message_inbox) do
      add :content_id, :string
    end
  end
end
