defmodule DAU.Repo.Migrations.CreateUserMessageEvent do
  use Ecto.Migration

  def change do
    create table(:user_message_event) do
      add :name, :string
      add :query_id, references(:user_message_query, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:user_message_event, [:query_id])
  end
end
