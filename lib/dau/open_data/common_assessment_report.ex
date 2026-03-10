defmodule DAU.OpenData.CommonAssessmentReport do
  @moduledoc """
  Join schema connecting `feed_common` rows with `assessment_reports` rows.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "common_assessment_reports" do
    belongs_to :common, DAU.Feed.Common
    belongs_to :assessment_report, DAU.OpenData.AssessmentReport

    timestamps(type: :utc_datetime)
  end

  def changeset(common_assessment_report, attrs) do
    common_assessment_report
    |> cast(attrs, [:common_id, :assessment_report_id])
    |> validate_required([:common_id, :assessment_report_id])
    |> assoc_constraint(:common)
    |> assoc_constraint(:assessment_report)
    |> unique_constraint([:common_id, :assessment_report_id],
      name: :common_assessment_reports_unique_index
    )
  end
end
