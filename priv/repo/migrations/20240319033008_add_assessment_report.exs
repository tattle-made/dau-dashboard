defmodule DAU.Repo.Migrations.AddAssessmentReport do
  use Ecto.Migration

  def change do
    alter table(:feed_common) do
      add :assessment_report, :map
    end
  end
end
