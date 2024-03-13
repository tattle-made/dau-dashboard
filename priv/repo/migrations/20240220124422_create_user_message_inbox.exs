defmodule DAU.Repo.Migrations.CreateIncomingMessages do
  use Ecto.Migration

  def change do
    create table(:user_message_inbox) do
      add :mobile, :string
      add :name, :string
      add :type, :string
      add :timestamp, :string
      add :audio, :string, size: 1000
      add :video, :string, size: 1000
      add :image, :string, size: 1000
      add :text, :string, size: 1000
      # key for file in our s3
      add :file_key, :string
      add :file_hash, :string

      timestamps(type: :utc_datetime)
    end
  end
end
