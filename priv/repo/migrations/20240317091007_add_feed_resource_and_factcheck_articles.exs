defmodule DAU.Repo.Migrations.AddFeedResourceAndFactcheckArticles do
  use Ecto.Migration

  def change do
    alter table(:feed_common) do
      add :factcheck_articles, :map
      add :resources, :map
    end
  end
end
