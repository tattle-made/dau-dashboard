defmodule DAU.Repo.Migrations.CreateIncomingMessages do
  use Ecto.Migration

  def change do
    create table(:incoming_messages) do
      add :source, :string
      add :payload_id, :string
      add :payload_type, :string
      add :sender_phone, :string
      add :sender_name, :string
      add :context_id, :string
      add :context_gsid, :string
      add :payload_text, :string
      add :payload_caption, :string
      add :payload_url, :string
      add :payload_contenttype, :string
      add :file_key, :string
      add :file_hash, :string

      timestamps(type: :utc_datetime)
    end
  end
end
