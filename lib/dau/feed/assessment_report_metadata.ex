defmodule DAU.Feed.AssessmentReportMetadata do
  alias DAU.Feed.Common
  alias DAU.Feed.AssessmentReportMetadata
  alias DAU.Repo
  use Ecto.Schema
  import Ecto.Changeset

  @all_fields [:feed_common_id, :link_of_ar, :who_is_post_targeting, :language]

  schema "assessment_report_metadata" do
    field :link_of_ar, :string
    field :who_is_post_targeting, :string
    field :language, :string
    belongs_to :feed_common, Common

    timestamps(type: :utc_datetime)
  end

  def changeset(metadata, attrs \\ %{}) do
    metadata
    |> cast(attrs, @all_fields)
    |> validate_required([:link_of_ar, :who_is_post_targeting, :language, :feed_common_id])
    |> foreign_key_constraint(:feed_common_id)
  end

  def create_assessment_report_metadata(attrs \\ %{}) do
    %AssessmentReportMetadata{}
    |> AssessmentReportMetadata.changeset(attrs)
    |> Repo.insert()
  end

  def get_assessment_report_metadata_by_common_id(feed_common_id) do
    Repo.get_by!(AssessmentReportMetadata, feed_common_id: feed_common_id)
  end

  def update_assessment_report_metadata(feed_common_id, attrs) do
    case get_assessment_report_metadata_by_common_id(feed_common_id) do
      nil ->
        {:error, :not_found}

      assessment_report_metadata ->
        assessment_report_metadata
        |> AssessmentReportMetadata.changeset(attrs)
        |> Repo.update()
    end
  end

  def delete_assessment_report_metadata(feed_common_id) do
    case get_assessment_report_metadata_by_common_id(feed_common_id) do
      nil ->
        {:error, :not_found}

      assessment_report_metadata ->
        Repo.delete(assessment_report_metadata)
    end
  end
end
