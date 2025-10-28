defmodule DAU.Repo.Migrations.CreateSlackEvents do
  use Ecto.Migration

  def change do
    create table(:slack_events) do
      add :event_id, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create index(:slack_events, [:event_id])
  end
end
