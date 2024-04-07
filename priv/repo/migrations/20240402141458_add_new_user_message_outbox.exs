defmodule DAU.Repo.Migrations.AddNewUserMessageOutbox do
  use Ecto.Migration

  def change do
    create table(:user_message_outbox, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false
      add :sender_number, :string
      add :sender_name, :string
      add :reply_type, :string
      add :type, :string
      add :text, :text
      add :message, :map
      add :approved_by, references(:users)
      add :approval_status, :string
      add :delivery_status, :string
      add :delivery_report, :text
    end
  end
end
