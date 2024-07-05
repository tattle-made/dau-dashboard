defmodule DAU.Feed.AssessmentReportMetadataTest do
  alias DAU.Feed.Common
  alias DAU.Feed.AssessmentReportMetadata
  alias DAU.Feed.AssessmentReportMetadataAggregate
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
        target: "someone",
        language: :en,
        primary_theme: 0,
        secondary_theme: 1,
        third_theme: "some theme",
        claim_is_sectarian: "yes",
        gender: ["male", "female"],
        content_disturbing: 0,
        claim_category: 1,
        claim_logo: 0,
        org_logo: "Some Organization",
        frame_org: 0,
        medium_of_content: :video,
        feed_common_id: state.feed_common_id
      }

      {:ok, assessment_report_meta_entry} =
        AssessmentReportMetadata.create(attrs)

      assert assessment_report_meta_entry.feed_common_id == state.feed_common_id
      assert assessment_report_meta_entry.target == "someone"
      assert assessment_report_meta_entry.language == :en
      assert assessment_report_meta_entry.content_disturbing == 0
      assert assessment_report_meta_entry.medium_of_content == :video
    end

    test "fetch assessment report metadata by feed_common_id", state do
      # Add data to assessment report metadata table
      attrs = %{
        target: "someone",
        language: :en,
        primary_theme: 0,
        secondary_theme: 1,
        third_theme: "some theme",
        claim_is_sectarian: "yes",
        gender: ["male", "female"],
        content_disturbing: 0,
        claim_category: 1,
        claim_logo: 0,
        org_logo: "Some Organization",
        frame_org: 0,
        medium_of_content: :video,
        feed_common_id: state.feed_common_id
      }

      {:ok, assessment_report_meta_entry} =
        AssessmentReportMetadata.create(attrs)

      # Fetch based on feed_common_id
      fetched_entry =
        AssessmentReportMetadata.get_assessment_report_metadata(state.feed_common_id)

      assert fetched_entry.feed_common_id == state.feed_common_id
      assert fetched_entry.language == :en
      assert fetched_entry.medium_of_content == :video
      assert fetched_entry.gender == ["male", "female"]
    end

    test "update values of assessment report metadata", state do
      # create an exisiting record
      attrs = %{
        target: "someone",
        language: :en,
        primary_theme: 0,
        secondary_theme: 1,
        third_theme: "some theme",
        claim_is_sectarian: "yes",
        gender: ["male", "female"],
        content_disturbing: 0,
        claim_category: 1,
        claim_logo: 0,
        org_logo: "Some Organization",
        frame_org: 0,
        medium_of_content: :video,
        feed_common_id: state.feed_common_id
      }

      {:ok, assessment_report_meta_entry} =
        AssessmentReportMetadata.create(attrs)

      # update the record
      updated_attrs = %{
        target: "someone-edit",
        language: :hi,
        primary_theme: 4,
        secondary_theme: 5,
        third_theme: "some theme",
        claim_is_sectarian: "yes",
        gender: ["trans_male", "female", "trans_female", "lgbqia"],
        content_disturbing: 0,
        claim_category: 1,
        claim_logo: 0,
        org_logo: "some-org-edit",
        frame_org: 0,
        medium_of_content: :audio,
        feed_common_id: state.feed_common_id
      }

      {:ok, updated_entry} =
        AssessmentReportMetadata.update(
          state.feed_common_id,
          updated_attrs
        )

      assert updated_entry.target == "someone-edit"
      assert updated_entry.language == :hi
      assert updated_entry.org_logo == "some-org-edit"
      assert updated_entry.medium_of_content == :audio
      assert updated_entry.gender == ["trans_male", "female", "trans_female", "lgbqia"]
    end

    test "delete a entry in assessment report metadata", state do
      # create an exisiting record
      attrs = %{
        target: "someone",
        language: :en,
        primary_theme: 0,
        secondary_theme: 1,
        third_theme: "some theme",
        claim_is_sectarian: "yes",
        gender: ["male", "female"],
        content_disturbing: 0,
        claim_category: 1,
        claim_logo: 0,
        org_logo: "Some Organization",
        frame_org: 0,
        medium_of_content: :video,
        feed_common_id: state.feed_common_id
      }

      {:ok, assessment_report_meta_entry} =
        AssessmentReportMetadata.create(attrs)

      # delete it - takes entire changeset
      {:ok, deleted_entry} =
        AssessmentReportMetadata.delete(state.feed_common_id)

      assert_raise Ecto.NoResultsError, fn ->
        AssessmentReportMetadataAggregate
        |> Repo.get_by!(feed_common_id: state.feed_common_id)
      end

      assert_raise Ecto.NoResultsError, fn ->
        AssessmentReportMetadataAggregate
        |> Repo.get!(deleted_entry.id)
      end
    end
  end
end
