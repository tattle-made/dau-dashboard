defmodule DAU.Repo.Migrations.CreateOutgoingMessages do
  use Ecto.Migration

  def change do
    create table(:user_message_outbox) do
      add :mobile, :string
      add :name, :string
      add :timestamp, :string
      add :type, :string
      add :text, :string
      add :image, :string
      add :video, :string

      timestamps(type: :utc_datetime)
    end
  end
end
