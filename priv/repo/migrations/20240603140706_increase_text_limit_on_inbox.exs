defmodule DAU.Repo.Migrations.IncreaseTextLimitOnInbox do
  use Ecto.Migration

  def change do
    alter table(:user_message_inbox) do
      modify :caption, :text
      modify :user_input_text, :text
    end
  end
end
