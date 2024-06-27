defmodule DAU.Feed.AssessmentReportMetadataTest do
  alias DAU.Feed.Common
  alias DAU.Feed.AssessmentReportMetadata
  alias DAU.Repo
  use DAU.DataCase

  describe "CRUD for assessment report metadata" do
    setup do
      common =
        %Common{}
        |> Common.changeset(%{
          media_urls: ["https://example.com/video1.mp4"],
          media_type: :video,
          sender_number: "1234567890"
        })
        |> Repo.insert!()

      feed_common_id = common.id
      {:ok, feed_common_id: feed_common_id}
    end

    test "create form entry", state do
      attrs = %{
        link_of_ar: "https://example.com/assessment-report",
        who_is_post_targeting: "someone",
        language: "en",
        feed_common_id: state.feed_common_id
      }

      {:ok, assessment_report_meta_entry} =
        AssessmentReportMetadata.create_assessment_report_metadata(attrs)

      assert assessment_report_meta_entry.link_of_ar == "https://example.com/assessment-report"
      assert assessment_report_meta_entry.who_is_post_targeting == "someone"
      assert assessment_report_meta_entry.language == "en"
      assert assessment_report_meta_entry.feed_common_id == state.feed_common_id
    end

    test "fetch assessment report metadata by feed_common_id", state do
      # Add data to assessment report metadata table
      attrs = %{
        link_of_ar: "https://example.com/assessment-report",
        who_is_post_targeting: "someone",
        language: "hi",
        feed_common_id: state.feed_common_id
      }

      {:ok, assessment_report_meta_entry} =
        AssessmentReportMetadata.create_assessment_report_metadata(attrs)

      # Fetch based on feed_common_id
      fetched_entry =
        AssessmentReportMetadata.get_assessment_report_metadata_by_common_id(state.feed_common_id)

      assert fetched_entry.link_of_ar == "https://example.com/assessment-report"
      assert fetched_entry.who_is_post_targeting == "someone"
      assert fetched_entry.language == "hi"
      assert fetched_entry.feed_common_id == state.feed_common_id
    end

    test "update values of assessment report metadata", state do
      # create an exisiting record
      attrs = %{
        link_of_ar: "https://example.com/assessment-report",
        who_is_post_targeting: "someone",
        language: "en",
        feed_common_id: state.feed_common_id
      }

      {:ok, assessment_report_meta_entry} =
        AssessmentReportMetadata.create_assessment_report_metadata(attrs)

      # update the record
      updated_attrs = %{
        link_of_ar: "https://example.com/assessment-report",
        who_is_post_targeting: "none",
        language: "ta",
        feed_common_id: state.feed_common_id
      }

      {:ok, updated_entry} =
        AssessmentReportMetadata.update_assessment_report_metadata(
          state.feed_common_id,
          updated_attrs
        )

      assert updated_entry.link_of_ar == "https://example.com/assessment-report"
      assert updated_entry.who_is_post_targeting == "none"
      assert updated_entry.language == "ta"
      assert updated_entry.feed_common_id == state.feed_common_id
    end

    test "delete a entry in assessment report metadata", state do
      # create an exisiting record
      attrs = %{
        link_of_ar: "https://example.com/assessment-report",
        who_is_post_targeting: "someone",
        language: "en",
        feed_common_id: state.feed_common_id
      }

      {:ok, assessment_report_meta_entry} =
        AssessmentReportMetadata.create_assessment_report_metadata(attrs)

      # delete it - takes entire changeset
      {:ok, deleted_entry} =
        AssessmentReportMetadata.delete_assessment_report_metadata(state.feed_common_id)

      assert_raise Ecto.NoResultsError, fn ->
        AssessmentReportMetadata
        |> Repo.get_by!(feed_common_id: state.feed_common_id)
      end

      assert_raise Ecto.NoResultsError, fn ->
        AssessmentReportMetadata
        |> Repo.get!(deleted_entry.id)
      end
    end
  end
end
