defmodule DAU.Repo.Migrations.CreateAssessmentReportMetadata do
  use Ecto.Migration

  def change do
    create table(:assessment_report_metadata) do
      add :feed_common_id, references(:feed_common, on_delete: :nothing)
      add :link, :string
      add :target, :string
      add :language, :string
      add :primary_theme, :integer
      add :secondary_theme, :integer
      add :third_theme, :string
      add :claim_is_sectarian, :string
      add :content_disturbing, :integer
      add :claim_category, :integer
      add :claim_logo, :integer
      add :org_logo, :string
      add :frame_org, :integer
      add :medium_of_content, :string

      timestamps(type: :utc_datetime)
    end

    create index(:assessment_report_metadata, [:feed_common_id])
  end
end
