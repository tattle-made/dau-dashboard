defmodule DAU.OpenData.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tags" do
    field :name, :string
    field :slug, :string
    belongs_to :tags_category, DAU.OpenData.TagsCategory

    many_to_many :commons, DAU.Feed.Common, join_through: DAU.OpenData.CommonTag

    timestamps(type: :utc_datetime)
  end

  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name, :slug, :tags_category_id])
    |> validate_required([:name, :slug])
    |> unique_constraint(:slug)
    |> assoc_constraint(:tags_category)
  end
end
