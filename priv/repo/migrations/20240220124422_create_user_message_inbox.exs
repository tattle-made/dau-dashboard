defmodule DAU.Repo.Migrations.CreateIncomingMessages do
  use Ecto.Migration

  def change do
    create table(:user_message_inbox) do
      add :sender_number, :string
      add :sender_name, :string
      add :media_type, :string
      add :path, :string
      # key for file in our s3
      add :file_key, :string
      add :file_hash, :string

      timestamps(type: :utc_datetime)
    end
  end
end
