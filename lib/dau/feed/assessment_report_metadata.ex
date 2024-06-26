defmodule DAU.Feed.AssessmentReportMetadata do
  alias DAU.Feed.Common
  use Ecto.Schema
  import Ecto.Changeset

  @all_fields [:feed_common_id, :link_of_ar, :who_is_post_targeting, :language]

  schema "assessment_report_metadata" do
    field :link_of_ar, :string
    field :who_is_post_targeting, :string
    field :language, :string
    belongs_to :feed_common, Common

    timestamps(type: :utc_datetime)
  end

  def changeset(metadata, attrs \\ %{}) do
    metadata
    |> cast(attrs, @all_fields)
    |> validate_required([:link_of_ar, :who_is_post_targeting, :language, :feed_common_id])
    |> foreign_key_constraint(:feed_common_id)
  end
end
