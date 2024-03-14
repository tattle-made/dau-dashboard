defmodule DAU.Repo.Migrations.CreateFeedExpertSubmittedResources do
  use Ecto.Migration

  def change do
    create table(:feed_expert_submitted_resources) do
      add :text, :text
      add :feed_id, references(:feed_common, on_delete: :nothing)
      add :user, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:feed_expert_submitted_resources, [:feed_id])
  end
end
