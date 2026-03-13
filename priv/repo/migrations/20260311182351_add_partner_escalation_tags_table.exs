defmodule DAU.Repo.Migrations.AddPartnerEscalationTagsTable do
  use Ecto.Migration

  def change do
    create table(:partner_escalation_tags) do
      add :partner_escalation_id,
          references(:partner_escalations, on_delete: :delete_all),
          null: false

      add :tag_id, references(:tags, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:partner_escalation_tags, [:partner_escalation_id, :tag_id],
             name: :partner_escalation_tags_unique_index
           )
  end
end
