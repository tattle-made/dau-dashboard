defmodule DAU.Repo.Migrations.CreateFeedUserResponses do
  use Ecto.Migration

  def change do
    create table(:feed_user_responses) do
      add :text, :text
      add :feed_id, references(:feed_common, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:feed_user_responses, [:feed_id])
  end
end
