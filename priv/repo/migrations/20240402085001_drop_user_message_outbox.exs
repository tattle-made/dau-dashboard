defmodule DAU.Repo.Migrations.AlterUserMessageOutbox do
  use Ecto.Migration

  def change do
    drop_if_exists table(:user_message_outbox)
  end
end
