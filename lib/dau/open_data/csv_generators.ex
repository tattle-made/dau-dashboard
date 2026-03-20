defmodule DAU.OpenData.CsvGenerators do

  @moduledoc """
  Module to generate CSV for the open datasets: The tipline data and The other sources dataset (Partner Escalations and Assessment Reports Tables).

  The functions 'get_other_sources_csv' and 'get_tipline_csv' generate CSVs and output them in the tmp directory.

  These function use the same base query as the ones used to fetch data for the UI Tables (from the respective Query modules), but without any applied filters.
  """
  import Ecto.Query, warn: false
  alias DAU.OpenData.OtherSourcesOpenQuery
  alias DAU.OpenData.FeedOpenQuery

  def get_other_sources_csv do
    rows = OtherSourcesOpenQuery.get_other_sources_rows_for_csv()

    headers = [
      "Preview",
      "count",
      "Languages",
      "Assessment Report",
      "Tools Used",
      "Observations",
      "Date"
    ]

    data = rows |> Enum.map(fn row -> extract_other_sources_row_values(row) end)

    csv_data = [headers | data]

    csv =
      csv_data
      |> CSV.encode()
      |> Enum.to_list()
      |> IO.iodata_to_binary()

    File.write!("tmp/other_sources_data.csv", csv)
  end

  def extract_other_sources_row_values(row) do
    [
      get_preview_text("text", row.preview_url),
      humanize_other_sources_count(row.count),
      extract_languages_from_tags(row),
      row.assessment_report_link || "-",
      row.tools_used |> List.wrap() |> stringify_list(),
      row.observations |> List.wrap() |> stringify_list(),
      humanize_date(row.date)
    ]
  end

  def get_tipline_csv do
    rows =
      FeedOpenQuery.get_common_feed_rows_for_csv()

    headers = [
      "Preview",
      "Media Type",
      "Tags",
      "Factcheck Articles",
      "Assessment Report",
      "Assessment Report Tools Used",
      "Assessment Report Observations",
      "Verification Status",
      "Received On"
    ]

    data = rows |> Enum.map(fn row -> extract_tipline_row_values(row) end)

    csv_data = [headers | data]

    csv =
      csv_data
      |> CSV.encode()
      |> Enum.to_list()
      |> IO.iodata_to_binary()

    File.write!("tmp/tipline_data.csv", csv)
  end

  def extract_tipline_row_values(row) do
    [
      get_preview_text(row.media_type, row.media_urls |> list_or_empty() |> List.first()),
      to_string(row.media_type),
      get_tags_labels(row.tag_joins),
      get_factcheck_articles_urls(row.factcheck_articles),
      report_link(row),
      report_tools(row),
      report_observations(row),
      to_string(row.verification_status),
      humanize_date(row.inserted_at)
    ]
  end

  defp get_preview_text(type, url) do
    type = to_string(type)

    cond do
      type in ["image", "video", "audio"] and not is_nil(url) ->
        url

      type in ["image", "video", "audio"] ->
        "-"

      type == "text" and is_nil(url) ->
        "-"

      type == "text" ->
        String.slice(url, 0..30) <> "..."

      true ->
        "-"
    end
  end

  defp get_factcheck_articles_urls(articles) do
    articles
    |> list_or_empty()
    |> Enum.filter(fn
      %{approved: true} -> true
      _ -> false
    end)
    |> Enum.map(fn
      %{url: url} -> url
      _ -> nil
    end)
    |> stringify_list()
  end

  defp get_tags_labels(tags) do
    tags
    |> list_or_empty()
    |> Enum.flat_map(fn
      %{name: name} -> [name]
      %{"name" => name} -> [name]
      name when is_binary(name) -> [name]
      _ -> []
    end)
    |> stringify_list()
  end

  defp humanize_date(nil), do: ""

  defp humanize_date(date) do
    Timex.to_datetime(date, "Asia/Calcutta")
    |> Calendar.strftime("%a %d-%m-%Y")
  end

  def report_tools(common) do
    common
    |> first_assessment_report()
    |> case do
      nil -> "-"
      report -> report.tools_used |> List.wrap() |> stringify_list()
    end
  end

  def report_observations(common) do
    common
    |> first_assessment_report()
    |> case do
      nil -> "-"
      report -> report.observations |> List.wrap() |> stringify_list()
    end
  end

  def report_link(common) do
    case first_assessment_report(common) do
      nil -> "-"
      report -> report.assessment_report_link || "-"
    end
  end

  defp first_assessment_report(common) do
    common
    |> Map.get(:open_data_assessment_reports, [])
    |> case do
      %Ecto.Association.NotLoaded{} -> []
      reports -> reports
    end
    |> List.wrap()
    |> List.first()
  end

  defp humanize_other_sources_count(count) do
    case count do
      nil -> 1
      _ -> count
    end
  end

  defp extract_languages_from_tags(row) do
    row.tags
    |> list_or_empty()
    |> Enum.flat_map(fn
      %{"name" => name} -> [name]
      %{name: name} -> [name]
      name when is_binary(name) -> [name]
      _ -> []
    end)
    |> stringify_list()
  end

  defp list_or_empty(%Ecto.Association.NotLoaded{}), do: []
  defp list_or_empty(nil), do: []
  defp list_or_empty(list) when is_list(list), do: list
  defp list_or_empty(_), do: []

  defp stringify_list(list) when is_list(list) do
    list
    |> Enum.reject(&is_nil/1)
    |> Enum.map(&to_string/1)
    |> Jason.encode!()
  end

  defp stringify_list(value), do: Jason.encode!([to_string(value)])
end
