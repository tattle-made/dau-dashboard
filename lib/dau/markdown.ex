defmodule DAU.Markdown do
  @moduledoc """
  This module is used to format the raw text that we receive from slack (during slack integration).
  """
  def render(raw) when is_binary(raw) do
    raw
    |> preprocess_slack_syntax()
    |> Earmark.as_html!()
    |> HtmlSanitizeEx.basic_html()
    |> add_link_styling()
    |> Phoenix.HTML.raw()
  end

  def render(raw) do
    raw
  end

  # Add styling to links, preserving existing attributes
  defp add_link_styling(html) do
    html
    |> String.replace(~r/<a(\s+[^>]*)>/, fn match ->
      # Check if class attribute already exists
      if String.contains?(match, "class=\"") do
        # Add to existing class
        String.replace(match, ~r/class=\"([^\"]*)\"/, "class=\\1 text-blue-600 hover:underline hover:text-blue-800 transition-colors\"")
      else
        # Add new class attribute
        String.replace(match, "<a", "<a class=\"text-blue-600 hover:underline hover:text-blue-800 transition-colors\"")
      end
    end)
  end

  # --- Preprocessing helpers ---
  defp preprocess_slack_syntax(text) do
    text
    |> replace_slack_links()
    |> replace_single_star_bold()
  end

  # <url|label>  ->  [label](url)
  defp replace_slack_links(text) do
    Regex.replace(~r/<([^>|]+)\|([^>]+)>/, text, "[\\2](\\1)")
  end

  # Convert Slack-style *bold* (single stars) -> **bold**
  # Avoid touching **already bold** and skip newlines inside
  defp replace_single_star_bold(text) do
    Regex.replace(~r/(?<!\*)\*([^*\n]+)\*(?!\*)/, text, "**\\1**")
  end
end
