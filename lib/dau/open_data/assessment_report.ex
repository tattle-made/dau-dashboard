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
    :remarks
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

    many_to_many :commons, DAU.Feed.Common, join_through: DAU.OpenData.CommonAssessmentReport

    timestamps(type: :utc_datetime)
  end

  def changeset(assessment_report, attrs \\ %{}) do
    assessment_report
    |> cast(attrs, @fields)
    |> unique_constraint(:assessment_report_link,
      name: :assessment_reports_assessment_report_link_unique_index
    )
  end
end
