defmodule DAU.Repo.Migrations.AddTimestampsToOutbox do
  use Ecto.Migration

  def change do
    alter table(:user_message_outbox) do
      timestamps(type: :utc_datetime)
    end
  end
end
