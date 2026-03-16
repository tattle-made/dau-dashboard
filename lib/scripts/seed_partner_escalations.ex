defmodule Scripts.SeedPartnerEscalations do
  @moduledoc """
  Seeds `partner_escalations` from the open-data CSV.
  """

  alias DAU.OpenData.PartnerEscalation
  alias DAU.Repo

  @default_csv_path "priv/static/open_data/partner_escalations.csv"

  def run(csv_path \\ @default_csv_path) do
    csv_path
    |> File.stream!()
    |> CSV.decode!(headers: true, escape_max_lines: 200)
    |> Enum.with_index(2)
    |> Enum.reduce(%{ok: 0, skipped: 0, error: 0}, fn {row, line_no}, acc ->
      attrs = row_to_attrs(row)

      case maybe_insert_row(attrs) do
        :ok ->
          %{acc | ok: acc.ok + 1}

        :skipped ->
          IO.puts("Skipping duplicate row at CSV line #{line_no}: #{attrs.uuid}")

          %{acc | skipped: acc.skipped + 1}

        {:error, changeset} ->
          IO.puts("Failed to insert row at CSV line #{line_no}: #{inspect(changeset)}")
          %{acc | error: acc.error + 1}
      end
    end)
    |> then(fn summary ->
      IO.puts(
        "Partner escalations seeding finished. Inserted: #{summary.ok}, Skipped: #{summary.skipped}, Failed: #{summary.error}"
      )

      summary
    end)
  end

  defp maybe_insert_row(%{uuid: uuid} = attrs) when is_binary(uuid) do
    case Ecto.UUID.cast(uuid) do
      {:ok, _} ->
        if Repo.get_by(PartnerEscalation, uuid: uuid), do: :skipped, else: insert_row(attrs)

      :error ->
        {:error, %{uuid: {"is invalid", []}}}
    end
  end

  defp maybe_insert_row(attrs), do: insert_row(attrs)

  defp insert_row(attrs) do
    %PartnerEscalation{}
    |> PartnerEscalation.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, _record} -> :ok
      {:error, changeset} -> {:error, changeset}
    end
  end

  defp row_to_attrs(row) do
    %{
      date: parse_date(Map.get(row, "Date")),
      count: parse_int(Map.get(row, "count")),
      media_urls: parse_string_array(Map.get(row, "media_urls")),
      language_of_content:
        blank_to_nil(Map.get(row, "Language of Content") || Map.get(row, "Language of Contentt")),
      tools_used: parse_string_array(Map.get(row, "Tools Used")),
      observations: parse_string_array(Map.get(row, "Observations")),
      remarks: blank_to_nil(Map.get(row, "Remarks")),
      uuid: blank_to_nil(Map.get(row, "uuid"))
    }
  end

  defp parse_date(nil), do: nil

  defp parse_date(value) when is_binary(value) do
    value = String.trim(value)

    case String.split(value, "/") do
      [day, month, year] ->
        with {day_int, ""} <- Integer.parse(day),
             {month_int, ""} <- Integer.parse(month),
             {year_int, ""} <- Integer.parse(year),
             {:ok, date} <- Date.new(year_int, month_int, day_int) do
          date
        else
          _ -> nil
        end

      _ ->
        nil
    end
  end

  defp parse_date(_), do: nil

  defp parse_int(nil), do: nil

  defp parse_int(value) when is_binary(value) do
    case Integer.parse(String.trim(value)) do
      # match only pure int
      {int, _} -> int
      :error -> nil
    end
  end

  defp parse_int(value) when is_integer(value), do: value
  defp parse_int(_), do: nil

  defp parse_string_array(nil), do: []
  defp parse_string_array(""), do: []

  defp parse_string_array(value) when is_binary(value) do
    value = String.trim(value)

    if value == "" do
      []
    else
      case Jason.decode(value) do
        {:ok, list} when is_list(list) ->
          Enum.map(list, &to_clean_string/1)

        _ ->
          [value]
      end
    end
  end

  defp parse_string_array(value) when is_list(value), do: Enum.map(value, &to_clean_string/1)
  defp parse_string_array(_), do: []

  defp to_clean_string(value) when is_binary(value), do: String.trim(value)
  defp to_clean_string(value), do: to_string(value)

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
