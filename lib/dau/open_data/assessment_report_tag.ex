defmodule DAU.OpenData.AssessmentReportTag do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "assessment_report_tags" do
    belongs_to :assessment_report, DAU.OpenData.AssessmentReport
    belongs_to :tag, DAU.OpenData.Tag

    timestamps(type: :utc_datetime)
  end

  def changeset(assessment_report_tag, attrs) do
    assessment_report_tag
    |> cast(attrs, [:assessment_report_id, :tag_id])
    |> validate_required([:assessment_report_id, :tag_id])
    |> assoc_constraint(:assessment_report)
    |> assoc_constraint(:tag)
    |> unique_constraint([:assessment_report_id, :tag_id],
      name: :assessment_report_tags_unique_index
    )
  end
end
