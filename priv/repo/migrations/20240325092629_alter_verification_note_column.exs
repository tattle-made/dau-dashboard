defmodule DAU.Repo.Migrations.AlterVerificationNoteColumn do
  use Ecto.Migration

  def change do
    alter table(:feed_common) do
      modify :verification_note, :text
    end
  end
end
