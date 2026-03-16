defmodule DAU.Repo.Migrations.AddAssessmentReportTagsTable do
  use Ecto.Migration

  def change do
    create table(:assessment_report_tags) do
      add :assessment_report_id,
          references(:assessment_reports, on_delete: :delete_all),
          null: false

      add :tag_id, references(:tags, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:assessment_report_tags, [:assessment_report_id, :tag_id],
             name: :assessment_report_tags_unique_index
           )
  end
end
