defmodule DAU.Feed.AssessmentReportMetadataRepository do
  alias DAU.Feed.AssessmentReportMetadata
  alias DAU.Feed.Common
  alias DAU.Repo

  def create(attrs \\ %{}) do
    %AssessmentReportMetadata{}
    |> AssessmentReportMetadata.changeset(attrs)
    |> Repo.insert()
  end

  def get(feed_common_id) do
    Repo.get_by(AssessmentReportMetadata, feed_common_id: feed_common_id)
  end

  def update(feed_common_id, attrs) do
    case get(feed_common_id) do
      nil ->
        {:error, :not_found}

      assessment_report_metadata ->
        assessment_report_metadata
        |> AssessmentReportMetadata.changeset(attrs)
        |> Repo.update()
    end
  end

  def delete(feed_common_id) do
    case get(feed_common_id) do
      nil ->
        {:error, :not_found}

      assessment_report_metadata ->
        Repo.delete(assessment_report_metadata)
    end
  end

  def report_exists?(feed_common_id) do
    case get(feed_common_id) do
      nil -> false
      _ -> true
    end
  end

  def fetch_all do
    Repo.all(AssessmentReportMetadata)
  end

  def get_assessment_report_url(feed_common_id) do
    case Repo.get(Common, feed_common_id) do
      nil ->
        nil

      feed_common ->
        case feed_common.assessment_report do
          nil ->
            nil

          assessment_report ->
            assessment_report.url
        end
    end
  end
end
