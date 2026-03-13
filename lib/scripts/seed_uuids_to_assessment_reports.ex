defmodule Scripts.SeedUuidsToAssessmentReports do
  @moduledoc """
  Script to add UUIDs to Assessment Report entries from the same seeding csv file, in case there are
  entries already in the table
  """

  alias DAU.OpenData.AssessmentReport
  alias DAU.Repo
  require Logger

  @default_csv_path "priv/static/open_data/assessment_reports.csv"

  def run(csv_path \\ @default_csv_path) do
    csv_path
    |> File.stream!()
    |> CSV.decode!(headers: true, escape_max_lines: 200)
    |> Enum.with_index(2)
    |> Enum.reduce(%{ok: 0, skipped: 0, error: 0}, fn {row, line_no}, acc ->
      attrs = row_to_attrs(row)

      case maybe_update_row(attrs) do
        :ok ->
          %{acc | ok: acc.ok + 1}

        :skipped ->
          IO.puts(
            "Skipping row at CSV line #{line_no}: #{attrs.assessment_report_link}"
          )

          %{acc | skipped: acc.skipped + 1}

        {:error, changeset} ->
          IO.puts("Failed to update row at CSV line #{line_no}: #{inspect(changeset.errors)}")
          %{acc | error: acc.error + 1}
      end
    end)
    |> then(fn summary ->
      IO.puts(
        "Assessment reports update with uuids finished. Updated: #{summary.ok}, Skipped: #{summary.skipped}, Failed: #{summary.error}"
      )

      summary
    end)
  end

  defp maybe_update_row(attrs) do
    assessment_report_link = attrs.assessment_report_link
    uuid = attrs.uuid

    if is_nil(uuid) do
      Logger.error(
        "Missing uuid for Assessment Report Link: #{assessment_report_link}, skipping."
      )

      :skipped
    else
    case Repo.get_by(AssessmentReport, assessment_report_link: assessment_report_link) do
      %AssessmentReport{} = ar ->
        case ar.uuid do
          nil ->
            case ar
                 |> AssessmentReport.changeset(%{uuid: uuid})
                 |> Repo.update() do
              {:ok, _} ->
                :ok

              {:error, error} ->
                Logger.error(
                  "Error while updating uuid of Report with id = #{ar.id}, skipping this entry: #{IO.inspect(error)}"
                )

                {:error, error}
            end

          _uuid ->
            :skipped
        end

      _ ->
        Logger.error(
          "Could not Fetch Assessment report with link: #{assessment_report_link}, skipping."
        )

        :skipped
    end
    end
  end

  defp row_to_attrs(row) do
    %{
      assessment_report_link: blank_to_nil(Map.get(row, "Assessment Report Link")),
      uuid: blank_to_nil(Map.get(row, "uuid"))
    }
  end

  defp blank_to_nil(nil), do: nil

  defp blank_to_nil(value) when is_binary(value) do
    value
    |> String.trim()
    |> case do
      "" -> nil
      trimmed -> trimmed
    end
  end

  defp blank_to_nil(value), do: value
end
