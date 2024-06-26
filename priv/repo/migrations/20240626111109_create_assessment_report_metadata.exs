defmodule DAU.Repo.Migrations.CreateAssessmentReportMetadata do
  use Ecto.Migration

  def change do
    create table(:assessment_report_metadata) do
      add :link_of_ar, :string
      add :who_is_post_targeting, :string
      add :language, :string
      add :feed_common_id, references(:feed_common, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:assessment_report_metadata, [:feed_common_id])
  end
end
