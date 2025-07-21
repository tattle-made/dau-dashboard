defmodule DAU.Repo.Migrations.UpdateEscalationTableFieldTypes do
  use Ecto.Migration

  def change do
    alter table(:escalation_form_entries) do
      modify :media_link, :text, null: false
      modify :emails_for_slack, :text, null: false
    end
  end
end
