defmodule DAU.Repo.Migrations.ChangePathToText do
  use Ecto.Migration

  def change do
    alter table(:user_message_inbox) do
      modify :path, :text
    end

  end
end
