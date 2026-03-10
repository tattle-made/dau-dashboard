defmodule Scripts.GetUrlsFromCommon do
  alias DAU.Feed.Common
  alias DAU.Repo
  import Ecto.Query

  @moduledoc """
  Script to extract urls from the feed-commons table.

  For all the rows with media_type = "text", this script fetches the first occuring proper url for that row.

  It outputs a JSON file with {id, url} objects in the /tmp folder.
  """

  @default_output_path "tmp/common_text_urls.json"

  def extract_first_url_for_puppeteer(text) when is_binary(text) do
    # The Regex:
    # 1. \b(?:https?:\/\/|www\.) -> Mandatory prefix (Prevents sentence-typo matches)
    # 2. [a-zA-Z0-9\-\.]+ -> Handles infinite subdomains/dots
    # 3. (?:\/\S*)? -> Greedily grabs the path/query params until it hits a space (\S)
    regex = ~r/\b(?:https?:\/\/|www\.)[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,}(?:\/\S*)?/i

    case Regex.run(regex, text) do
      [url | _] ->
        url
        # 1. Remove trailing punctuation (periods, commas, etc. at the end of sentences)
        |> (&Regex.replace(~r/[.,)\]\}]+$/, &1, "")).()
        # 2. Prepend https:// if it only starts with www. (Puppeteer requires a protocol)
        |> (fn
              "www." <> _ = u -> "https://" <> u
              u -> u
            end).()

      _ ->
        nil
    end
  end

  # total: 1661,
   #failed: 35,

  #Failed row IDs: 419, 337, 395, 2613, 2614, 2927, 2934, 2926, 3033, 3075, 3088, 3038, 3077, 3087,
  #3073, 3079, 3765, 3074, 3099, 3080, 3061, 3078, 3076, 3110, 4334, 3519, 3465, 3738, 3258, 4155,
  #3688, 4490, 3983, 3966, 4483

  def run(output_path \\ @default_output_path) do
    queries =
      Common
      |> where([c], c.media_type == :text)
      |> select([c], %{id: c.id, media_urls: c.media_urls})
      |> Repo.all()

    extracted_or_failed =
      Enum.map(queries, fn %{id: id, media_urls: media_urls} ->
        text =
          case List.first(media_urls || []) do
            value when is_binary(value) -> value
            _ -> ""
          end

        url = extract_first_url_for_puppeteer(text)
        %{id: id, url: url}
      end)

    entries = Enum.reject(extracted_or_failed, &is_nil(&1.url))
    failed = Enum.filter(extracted_or_failed, &is_nil(&1.url))
    total = length(queries)
    failed_count = length(failed)

    output_path
    |> Path.dirname()
    |> File.mkdir_p!()

    output = Jason.encode_to_iodata!(entries, pretty: true)
    File.write!(output_path, output)

    failed_sample_ids =
      failed
      |> Enum.map_join(", ", &to_string(&1.id))

    IO.puts("Total entries processed: #{total}")
    IO.puts("Extraction failures: #{failed_count}")
    IO.puts("Wrote #{length(entries)} entries to #{output_path}")

    IO.puts(
      "Failed row IDs: #{if failed_count > 0, do: failed_sample_ids, else: "none"}"
    )

    {:ok,
     %{
       output_path: output_path,
       total: total,
       failed: failed_count,
       failed_ids_sample: if(failed_count > 0, do: failed_sample_ids, else: "")
     }}
  end
end
