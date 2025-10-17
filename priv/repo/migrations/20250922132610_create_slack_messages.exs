defmodule DAU.Repo.Migrations.CreateSlackMessages do
  use Ecto.Migration

  def change do
    create table(:slack_messages) do
      add :ts, :string
      add :ts_utc, :utc_datetime_usec, null: false
      add :team, :string
      add :user, :string
      add :text, :text
      add :urls, {:array, :string}
      add :files, {:array, :map}
      add :is_deleted, :boolean, default: false
      add :is_edited, :boolean, default: false
      add :is_broadcasted, :boolean, default: false
      add :channel_id, references(:slack_channels), null: false
      add :parent_id, references(:slack_messages), null: true

      timestamps(type: :utc_datetime)
    end
    create unique_index(:slack_messages, [:team, :channel_id, :ts],
    name: :slack_messages_team_channel_ts_index
  )
  end
end
