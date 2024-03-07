defmodule DAU.Repo.Migrations.CreateFeedCommon do
  use Ecto.Migration

  def change do
    create table(:feed_common) do
      add :media_urls, {:array, :string}
      add :verification_note, :string
      add :tags, {:array, :string}
      add :status, :string
      add :exact_count, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
