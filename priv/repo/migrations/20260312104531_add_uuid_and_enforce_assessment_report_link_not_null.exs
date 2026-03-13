defmodule DAU.Repo.Migrations.AddUuidAndEnforceAssessmentReportLinkNotNull do
  use Ecto.Migration

  def change do
    alter table(:assessment_reports) do
      add :uuid, :uuid
      modify :assessment_report_link, :string, null: false
    end

    create unique_index(:assessment_reports, [:uuid], name: :assessment_reports_uuid_unique_index)
  end
end
