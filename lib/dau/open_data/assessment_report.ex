defmodule DAU.OpenData.AssessmentReport do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [
    :date,
    :tipline_id,
    :media_urls,
    :assessment_report_link,
    :language_of_content,
    :tools_used,
    :observations,
    :remarks,
    :uuid
  ]

  @required_fields [
    :assessment_report_link,
  ]

  schema "assessment_reports" do
    field :date, :date
    field :tipline_id, :integer
    field :media_urls, {:array, :string}
    field :assessment_report_link, :string
    field :language_of_content, :string
    field :tools_used, {:array, :string}
    field :observations, {:array, :string}
    field :remarks, :string
    field :uuid, Ecto.UUID

    many_to_many :commons, DAU.Feed.Common, join_through: DAU.OpenData.CommonAssessmentReport
    many_to_many :tags, DAU.OpenData.Tag, join_through: DAU.OpenData.AssessmentReportTag

    timestamps(type: :utc_datetime)
  end

  def changeset(assessment_report, attrs \\ %{}) do
    assessment_report
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:assessment_report_link,
      name: :assessment_reports_assessment_report_link_unique_index
    )
    |> unique_constraint(:uuid,
      name: :assessment_reports_uuid_unique_index
    )
  end
end
