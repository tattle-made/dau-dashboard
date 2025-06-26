defmodule DAU.ExternalEscalation.FormEntry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "escalation_form_entries" do
    field :organization_name, :string
    field :submitter_name, :string
    field :submitter_designation, :string
    field :submitter_email, :string
    field :organization_country, :string
    field :escalation_media_type, {:array, Ecto.Enum}, values: [:audio, :video, :both]
    field :content_language, :string
    field :content_platform, Ecto.Enum, values: [:x, :whatsapp, :facebook, :instagram, :other]
    field :media_link, :string
    field :transcript, :string
    field :english_translation, :string
    field :additional_info, :string
    field :emails_for_slack, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(entry, params \\ %{}) do
    entry
    |> cast(params, [
      :organization_name,
      :submitter_name,
      :submitter_designation,
      :submitter_email,
      :organization_country,
      :escalation_media_type,
      :content_language,
      :content_platform,
      :media_link,
      :transcript,
      :english_translation,
      :additional_info,
      :emails_for_slack
    ])
    |> validate_required([
      :organization_name,
      :submitter_name,
      :submitter_designation,
      :submitter_email,
      :organization_country,
      :escalation_media_type,
      :content_language,
      :content_platform,
      :media_link,
      :emails_for_slack
    ])
    |> validate_format(:submitter_email, ~r/@/)
  end
end
