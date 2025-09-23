defmodule DAU.Repo.Migrations.CreateSlackChannels do
  use Ecto.Migration

  def change do
    create table(:slack_channels) do
      add :channel_id, :string, null: false
      add :channel_name, :string

      timestamps(type: :utc_datetime)
    end
  end
end
