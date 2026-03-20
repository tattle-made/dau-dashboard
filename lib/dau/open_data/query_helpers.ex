defmodule DAU.OpenData.QueryHelpers do

    @doc """
  Function to extract the first proper URL from a text. The text could be a paragraph with multiple urls.
  This is the same function used while extracting urls for downloading the thumbnails.
  """
  def extract_first_url_from_text(text) when is_binary(text) do
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
        # 2. Prepend https:// if it only starts with www.
        |> (fn
              "www." <> _ = u -> "https://" <> u
              u -> u
            end).()

      _ ->
        nil
    end
  end

end
