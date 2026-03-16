defmodule Scripts.SeedPartnerEscalationsTags do
  @moduledoc """
  Seeds partner_escalation_tags from PartnerEscalation.language_of_content.
  """

  alias DAU.OpenData
  alias DAU.OpenData.PartnerEscalation
  alias DAU.OpenData.PartnerEscalationTag
  alias DAU.OpenData.Tag
  alias DAU.Repo
  import Ecto.Query

  def run() do
    escalations =
      PartnerEscalation
      |> where([pe], not is_nil(pe.language_of_content))
      |> Repo.all()

    IO.puts("Processing #{length(escalations)} partner escalations...")

    Enum.each(escalations, &process_escalation/1)

    IO.puts("Done seeding partner_escalation_tags!")
  end

  defp process_escalation(%PartnerEscalation{} = escalation) do
    escalation.language_of_content
    |> parse_languages()
    |> Enum.each(fn language ->
      tag_name = "Language : #{language}"
      tag = find_tag(tag_name)

      case tag do
        nil ->
          IO.puts(
            "Language tag not found: '#{tag_name}' for partner_escalation_id: #{escalation.id}"
          )

        %Tag{id: tag_id} ->
          case Repo.get_by(PartnerEscalationTag,
                 partner_escalation_id: escalation.id,
                 tag_id: tag_id
               ) do
            nil ->
              case create_partner_escalation_tag(escalation.id, tag_id) do
                {:ok, _} -> :ok
                {:error, reason} ->
                  IO.puts(
                    "Failed to create PartnerEscalationTag for partner_escalation_id: #{escalation.id}, tag_id: #{tag_id}, reason: #{inspect(reason)}"
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

  defp create_partner_escalation_tag(partner_escalation_id, tag_id) do
    %PartnerEscalationTag{}
    |> PartnerEscalationTag.changeset(%{
      partner_escalation_id: partner_escalation_id,
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
        |> String.replace("+", " and ")
        |> String.replace("&", " and ")
        |> String.replace("/", " and ")
        |> String.replace(",", " and ")
        |> String.replace(~r/[^a-z\s]/, " ")
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
      "bangal" -> "Bangla"
      "punjabi" -> "Punjabi"
      "kannada" -> "Kannada"
      "sinhala" -> "Sinhala"
      "sinhalese" -> "Sinhala"
      "portuguese" -> "Portuguese"
      "greek" -> "Greek"
      "gujarati" -> "Gujarati"
      "nepali" -> "Nepali"
      "meitei" -> "Meitei"
      _ -> nil
    end
  end
end
