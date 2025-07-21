defmodule DAU.Repo.Migrations.CreateEscalationFormEntries do
  use Ecto.Migration

  def change do
    execute("""
    CREATE TYPE escalation_media_type AS ENUM ('audio', 'video', 'both');
    """)

    execute("""
    CREATE TYPE content_platform AS ENUM ('x', 'whatsapp', 'facebook', 'instagram', 'other');
    """)

    create table(:escalation_form_entries) do
      add :organization_name, :string, null: false
      add :submitter_name, :string, null: false
      add :submitter_designation, :string, null: false
      add :submitter_email, :string, null: false
      add :organization_country, :string, null: false

      add :escalation_media_type, {:array, :escalation_media_type}, null: false
      add :content_language, :string, null: false
      add :content_platform, :content_platform, null: false

      add :media_link, :string, null: false
      add :transcript, :text
      add :english_translation, :text
      add :additional_info, :text
      add :emails_for_slack, :string, null: false

      # NOTE: The field type for media_link ad emails_for_slack have been changed to :text in another migration file.

      timestamps(type: :utc_datetime)
    end

    create index(:escalation_form_entries, [:submitter_email])
  end
end
