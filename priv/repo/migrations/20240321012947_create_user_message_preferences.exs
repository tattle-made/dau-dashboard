defmodule DAU.Repo.Migrations.CreateUserMessagePreferences do
  use Ecto.Migration

  def change do
    create table(:user_message_preferences) do
      add :language, :string
      add :sender_number, :string

      timestamps(type: :utc_datetime)
    end
  end
end
