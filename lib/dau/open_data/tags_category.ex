defmodule DAU.OpenData.TagsCategory do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tags_categories" do
    field :category, :string
    field :slug, :string
    has_many :tags, DAU.OpenData.Tag

    timestamps(type: :utc_datetime)
  end

  def changeset(tags_category, attrs) do
    tags_category
    |> cast(attrs, [:category, :slug])
    |> validate_required([:category, :slug])
    |> unique_constraint(:slug)
  end
end
