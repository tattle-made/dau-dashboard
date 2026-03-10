defmodule DAU.Repo.Migrations.CreateAssessmentReports do
  use Ecto.Migration

  def change do
    create table(:assessment_reports) do
      add :date, :date
      add :tipline_id, :integer
      add :media_urls, {:array, :string}
      add :assessment_report_link, :string
      add :language_of_content, :string
      add :tools_used, {:array, :string}
      add :observations, {:array, :text}
      add :remarks, :text

      timestamps(type: :utc_datetime)
    end

    create unique_index(
             :assessment_reports,
             [:assessment_report_link],
             name: :assessment_reports_assessment_report_link_unique_index
           )
  end
end
