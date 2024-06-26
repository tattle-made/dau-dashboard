defmodule DAU.Feed.AssessmentReportMetadataTest do
  alias DAU.Feed.Common
  alias DAU.Feed.AssessmentReport
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
      IO.inspect(state.feed_common_id)

      attrs = %{
        link_of_ar: "https://example.com/assessment-report",
        who_is_post_targeting: "General public",
        language: "en",
        feed_common_id: state.feed_common_id
      }

      assessment_report_meta_entry =
        %DAU.Feed.AssessmentReportMetadata{}
        |> DAU.Feed.AssessmentReportMetadata.changeset(attrs)
        |> Repo.insert!()
    end
  end
end
