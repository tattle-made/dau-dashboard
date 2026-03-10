defmodule Scripts.SeedCommonAssessmentReports do
  @moduledoc """
  Seeds `common_assessment_reports` by linking `assessment_reports.tipline_id` to `feed_common.id`.
  """

  alias DAU.Feed.Common
  alias DAU.OpenData.AssessmentReport
  alias DAU.OpenData.CommonAssessmentReport
  alias DAU.Repo

  def run() do
    AssessmentReport
    |> Repo.all()
    |> Enum.reduce(%{ok: 0, skipped: 0, missing_common: 0, error: 0}, fn assessment_report, acc ->
      case maybe_insert_join(assessment_report) do
        :ok ->
          %{acc | ok: acc.ok + 1}

        :skipped ->
          %{acc | skipped: acc.skipped + 1}

        :missing_common ->
          %{acc | missing_common: acc.missing_common + 1}

        {:error, changeset} ->
          IO.puts(
            "Failed to create join for assessment_report_id=#{assessment_report.id}, tipline_id=#{inspect(assessment_report.tipline_id)}: #{inspect(changeset.errors)}"
          )

          %{acc | error: acc.error + 1}
      end
    end)
    |> then(fn summary ->
      IO.puts(
        "Common-assessment report join seeding finished. Inserted: #{summary.ok}, Skipped: #{summary.skipped}, Missing commons: #{summary.missing_common}, Failed: #{summary.error}"
      )

      summary
    end)
  end

  defp maybe_insert_join(%AssessmentReport{tipline_id: nil}), do: :skipped

  defp maybe_insert_join(%AssessmentReport{id: assessment_report_id, tipline_id: common_id}) do
    common = Repo.get(Common, common_id)

    cond do
      is_nil(common) ->
        :missing_common

      Repo.get_by(CommonAssessmentReport,
        common_id: common_id,
        assessment_report_id: assessment_report_id
      ) ->
        :skipped

      true ->
        %CommonAssessmentReport{}
        |> CommonAssessmentReport.changeset(%{
          common_id: common_id,
          assessment_report_id: assessment_report_id
        })
        |> Repo.insert()
        |> case do
          {:ok, _record} -> :ok
          {:error, changeset} -> {:error, changeset}
        end
    end
  end
end
