defmodule DAU.OpenData.CommonTag do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "common_tags" do
    belongs_to :common, DAU.Feed.Common
    belongs_to :tag, DAU.OpenData.Tag

    timestamps(type: :utc_datetime)
  end

  def changeset(common_tag, attrs) do
    common_tag
    |> cast(attrs, [:common_id, :tag_id])
    |> validate_required([:common_id, :tag_id])
    |> assoc_constraint(:common)
    |> assoc_constraint(:tag)
    |> unique_constraint([:common_id, :tag_id], name: :common_tags_unique_index)
  end
end
