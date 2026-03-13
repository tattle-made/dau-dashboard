defmodule Scripts.GetUrlsFromAssessmentReports do
  @moduledoc """
  Get the urls from the assessment reports table for downloading thumbnail through puppeteer.
  Outputs a JSON file with a list of {url, uuid} objects.
  """
  alias DAU.OpenData.AssessmentReport
  alias DAU.Repo
  import Ecto.Query

  @default_output_path "tmp/assessment_reports_urls.json"

  def run(output_path \\ @default_output_path) do
    reports =
      AssessmentReport
      |> where([ar], not is_nil(ar.media_urls) and ar.media_urls != [] and not is_nil(ar.uuid))
      |> Repo.all()

    entries =
      reports
      |> Enum.map(fn r ->
        url =
          r.media_urls
          |> Enum.find(&valid_url?/1)

        %{uuid: r.uuid, url: url}
      end)
      |> Enum.reject(fn entry -> is_nil(entry.url) or not valid_url?(entry.url) end)

    output_path
    |> Path.dirname()
    |> File.mkdir_p!()

    output = Jason.encode_to_iodata!(entries, pretty: true)
    File.write!(output_path, output)
  end

  defp valid_url?(url) when is_binary(url) do
    trimmed = String.trim(url)

    with %URI{scheme: scheme, host: host} <- URI.parse(trimmed),
         true <- scheme in ["http", "https"],
         true <- is_binary(host) and host != "" do
      true
    else
      _ -> false
    end
  end

  defp valid_url?(_), do: false
end
