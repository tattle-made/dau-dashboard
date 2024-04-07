defmodule DAU.Repo.Migrations.CreateUserMessageQuery do
  use Ecto.Migration

  def change do
    create table(:user_message_query) do
      add :status, :string
      add :feed_common_id, references(:feed_common, on_delete: :nothing)

      add :user_message_outbox_id,
          references(:user_message_outbox, type: :uuid, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:user_message_query, [:feed_common_id])
    create index(:user_message_query, [:user_message_outbox_id])
  end
end
