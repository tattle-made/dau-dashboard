defmodule DAU.Repo.Migrations.CreatePartnerEscalations do
  use Ecto.Migration

  def change do
    create table(:partner_escalations) do
      add :date, :date
      add :media_urls, {:array, :string}
      add :count, :integer
      add :language_of_content, :string
      add :tools_used, {:array, :string}
      add :observations, {:array, :text}
      add :remarks, :text
      add :uuid, :uuid, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:partner_escalations, [:uuid],
             name: :partner_escalations_uuid_unique_index
           )
  end
end
