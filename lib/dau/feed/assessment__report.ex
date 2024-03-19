defmodule DAU.Feed.AssessmentReport do
  alias DAU.Feed.AssessmentReport
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :url, :string
  end

  def changeset(%AssessmentReport{} = assessment_report, attrs \\ %{}) do
    assessment_report
    |> cast(attrs, [:url])
    |> validate_required([:url])
  end
end
