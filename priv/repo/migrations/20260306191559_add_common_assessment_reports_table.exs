defmodule DAU.Repo.Migrations.AddCommonAssessmentReportsTable do
  use Ecto.Migration

  def change do
    create table(:common_assessment_reports) do
      add :common_id, references(:feed_common, on_delete: :delete_all), null: false

      add :assessment_report_id, references(:assessment_reports, on_delete: :delete_all),
        null: false

      timestamps(type: :utc_datetime)
    end

    create index(:common_assessment_reports, [:common_id])
    create index(:common_assessment_reports, [:assessment_report_id])

    create unique_index(:common_assessment_reports, [:common_id, :assessment_report_id],
             name: :common_assessment_reports_unique_index
           )
  end
end
