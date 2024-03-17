defmodule DAU.Feed.FactcheckArticle do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :username, :string
    field :url, :string
    field :title, :string
    field :excerpt, :string
    field :publisher, :string
    field :author, :string
  end

  def changeset(profile, attrs \\ %{}) do
    profile
    |> cast(attrs, [:url, :title, :excerpt, :publisher, :author])
    |> validate_required([:username, :url])
  end
end
