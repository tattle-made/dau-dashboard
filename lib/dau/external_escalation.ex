defmodule DAU.ExternalEscalation do
  alias DAU.ExternalEscalation.FormEntry
  alias DAU.Repo
  require Logger

  def create_external_escalation(attrs) do
    %FormEntry{}
    |> FormEntry.changeset(attrs)
    |> Repo.insert()
  end

  def process_external_escalation_entry(params) do
    try do
      keys_map = %{
        "Organisation's name" => :organization_name,
        "Your name" => :submitter_name,
        "Your designation" => :submitter_designation,
        "Your email address" => :submitter_email,
        "Name of the country your fact-checking organisation is based in" =>
          :organization_country,
        "Type of media you'd like to escalate" => :escalation_media_type,
        "Language of the audio/video content being escalated" => :content_language,
        "On which platform was the audio/video content found?" => :content_platform,
        "Can you please share a link from the platform below?" => :media_link,
        "Transcript for non-English content (*transcripts should be in the original language script of the content and not in Roman text)" =>
          :transcript,
        "Translation of the content (translation should be provided in English)" =>
          :english_translation,
        "Please include any additional information such as links to relevant news stories or fact-checks, if any, that can help us understand the regional/ethnic context related to the piece of content you want us to analyse." =>
          :additional_info,
        "We will set-up a Slack channel with you where you can share audio/video files that you'd like for us to analyse. Please share email addresses of members from your organisation who should be on that channel for communication purposes." =>
          :emails_for_slack
      }

      processed_entry =
        Enum.reduce(params, %{}, fn {key, value}, acc ->
          case keys_map[key] do
            :escalation_media_type ->
              value =
                value
                |> Enum.map(fn val ->
                  case val do
                    "Audio file" -> :audio
                    "Video file" -> :video
                    "Both" -> :both
                    _ -> :unknown
                  end
                end)

              Map.put(acc, keys_map[key], value)

            :content_platform ->
              value =
                value
                |> String.downcase()
                |> case do
                  "facebook" -> "facebook"
                  "instagram" -> "instagram"
                  "whatsapp" -> "whatsapp"
                  "x" -> "x"
                  "other" -> "other"
                  _ -> "other"
                end

              Map.put(acc, keys_map[key], value)

            nil ->
              # Ignore unknown keys
              acc

            _ ->
              Map.put(acc, keys_map[key], value)
          end
        end)

      case create_external_escalation(processed_entry) do
        {:ok, entry} -> {:ok, entry}
        {:error, changeset} -> {:error, changeset}
      end
    rescue
      error ->
        Logger.error("EXTERNAL ESCALATION ERROR: #{inspect(error)}")
        {:error, error}
    end
  end

  def list_form_entries do
    Repo.all(FormEntry)
  end
end
