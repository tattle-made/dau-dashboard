defmodule Scripts.SeedAssessmentReportsTags do
  @moduledoc """
  Seeds assessment_report_tags from AssessmentReport.language_of_content.
  """

  alias DAU.OpenData
  alias DAU.OpenData.AssessmentReport
  alias DAU.OpenData.AssessmentReportTag
  alias DAU.OpenData.Tag
  alias DAU.Repo
  import Ecto.Query

  def run() do
    reports =
      AssessmentReport
      |> where([ar], not is_nil(ar.language_of_content))
      |> Repo.all()

    IO.puts("Processing #{length(reports)} assessment reports...")

    Enum.each(reports, &process_report/1)

    IO.puts("Done seeding assessment_report_tags!")
  end

  defp process_report(%AssessmentReport{} = report) do
    report.language_of_content
    |> parse_languages()
    |> Enum.each(fn language ->
      tag_name = "Language : #{language}"
      tag = find_tag(tag_name)

      case tag do
        nil ->
          IO.puts(
            "Language tag not found: '#{tag_name}' for assessment_report_id: #{report.id}"
          )

        %Tag{id: tag_id} ->
          case Repo.get_by(AssessmentReportTag,
                 assessment_report_id: report.id,
                 tag_id: tag_id
               ) do
            nil ->
              case create_assessment_report_tag(report.id, tag_id) do
                {:ok, _} -> :ok
                {:error, reason} ->
                  IO.puts(
                    "Failed to create AssessmentReportTag for assessment_report_id: #{report.id}, tag_id: #{tag_id}, reason: #{inspect(reason)}"
                  )
              end

            _existing ->
              :ok
          end
      end
    end)
  end

  defp find_tag(tag_name) do
    case Repo.get_by(Tag, name: tag_name) do
      nil ->
        slug = OpenData.normalize_tag(tag_name)
        Repo.get_by(Tag, slug: slug)

      tag ->
        tag
    end
  end

  defp create_assessment_report_tag(assessment_report_id, tag_id) do
    %AssessmentReportTag{}
    |> AssessmentReportTag.changeset(%{
      assessment_report_id: assessment_report_id,
      tag_id: tag_id
    })
    |> Repo.insert()
  end

  defp parse_languages(nil), do: []

  defp parse_languages(value) when is_binary(value) do
    value =
      value
      |> String.trim()
      |> String.downcase()

    cond do
      value in ["", "n/a", "na"] ->
        []

      true ->
        value
        |> String.replace(~r/\([^)]*\)/, " ")
        |> String.replace("&", " and ")
        |> String.replace("/", " and ")
        |> String.replace(",", " and ")
        |> String.replace(~r/\s+/, " ")
        |> String.split(~r/\s+and\s+/, trim: true)
        |> Enum.map(&String.trim/1)
        |> Enum.map(&normalize_language/1)
        |> Enum.reject(&is_nil/1)
        |> Enum.uniq()
    end
  end

  defp parse_languages(_), do: []

  defp normalize_language(value) do
    case value do
      "english" -> "English"
      "hindi" -> "Hindi"
      "urdu" -> "Urdu"
      "tamil" -> "Tamil"
      "marathi" -> "Marathi"
      "arabic" -> "Arabic"
      "telugu" -> "Telugu"
      "bengali" -> "Bangla"
      "bangla" -> "Bangla"
      _ -> nil
    end
  end
end
