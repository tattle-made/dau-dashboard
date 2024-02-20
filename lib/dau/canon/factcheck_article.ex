defmodule DAU.Canon.FactcheckArticle do
  use Ecto.Schema
  import Ecto.Changeset

  schema "factcheck_articles" do
    field :title, :string
    field :author, :string
    field :url, :string
    field :publisher, :string
    field :excerpt, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(factcheck_article, attrs) do
    factcheck_article
    |> cast(attrs, [:url, :title, :publisher, :author, :excerpt])
    |> validate_required([:url, :title, :publisher, :author, :excerpt])
  end
end
