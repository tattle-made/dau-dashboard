defmodule DAU.Repo.Migrations.CreateOutgoingMessages do
  use Ecto.Migration

  def change do
    create table(:outgoing_messages) do
      add :context_id, :string
      add :context_gsid, :string
      add :payload_text, :string
      add :payload_caption, :string
      add :payload_url, :string
      add :payload_contenttype, :string
      add :payload_type, :string

      timestamps(type: :utc_datetime)
    end
  end
end
