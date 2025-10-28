defmodule DAU.Repo.Migrations.CreateSlackChannels do
  use Ecto.Migration

  def change do
    create table(:slack_channels) do
      add :channel_id, :string, null: false
      add :channel_name, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:slack_channels, [:channel_id],
    name: :slack_channels_channel_id_index
  )
  end
end
