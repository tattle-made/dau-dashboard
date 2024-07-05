defmodule DAU.Feed.AssessmentReportMetadata do
  alias DAU.Feed.Common
  use Ecto.Schema
  import Ecto.Changeset

  @all_fields [
    :feed_common_id,
    :target,
    :language,
    :primary_theme,
    :secondary_theme,
    :third_theme,
    :claim_is_sectarian,
    :gender,
    :content_disturbing,
    :claim_category,
    :claim_logo,
    :org_logo,
    :frame_org,
    :medium_of_content
  ]

  schema "assessment_report_metadata" do
    field :target, :string
    field :language, Ecto.Enum, values: [:en, :hi, :ta, :te, :und]
    field :primary_theme, :integer
    field :secondary_theme, :integer
    field :third_theme, :string
    field :claim_is_sectarian, :string
    field :gender, {:array, :string}
    field :content_disturbing, :integer
    field :claim_category, :integer
    field :claim_logo, :integer
    field :org_logo, :string
    field :frame_org, :integer
    field :medium_of_content, Ecto.Enum, values: [:video, :audio, :link]
    belongs_to :feed_common, Common

    timestamps(type: :utc_datetime)
  end

  def changeset(metadata, attrs \\ %{}) do
    metadata
    |> cast(attrs, @all_fields)
    |> validate_required([:feed_common_id, :primary_theme, :frame_org, :medium_of_content])
    |> foreign_key_constraint(:feed_common_id)
  end
end
