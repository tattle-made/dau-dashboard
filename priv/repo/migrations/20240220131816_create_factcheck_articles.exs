defmodule DAU.Repo.Migrations.CreateFactcheckArticles do
  use Ecto.Migration

  def change do
    create table(:factcheck_articles) do
      add :url, :string
      add :title, :string
      add :publisher, :string
      add :author, :string
      add :excerpt, :string

      timestamps(type: :utc_datetime)
    end
  end
end
