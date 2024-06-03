defmodule DAU.Repo.Migrations.AlterCommonMediaUrlsType do
  use Ecto.Migration

  def change do
    alter table(:feed_common) do
      modify :media_urls, {:array, :text}
    end
  end
end
