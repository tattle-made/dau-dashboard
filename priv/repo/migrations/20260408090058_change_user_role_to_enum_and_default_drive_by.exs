defmodule DAU.Repo.Migrations.ChangeUserRoleToEnumAndDefaultDriveBy do
  use Ecto.Migration

  @roles_check "role IN ('admin','secratariat_associate','secratariat_manager','expert_factchecker','expert_forensic','drive_by')"

  def up do
    execute("UPDATE users SET role = 'drive_by' WHERE role = 'user' OR role IS NULL")

    alter table(:users) do
      modify :role, :string, default: "drive_by", null: false
    end

    create constraint(:users, :users_role_check, check: @roles_check)
  end

  def down do
    drop constraint(:users, :users_role_check)

    alter table(:users) do
      modify :role, :string, default: "user", null: true
    end

    execute("UPDATE users SET role = 'user' WHERE role = 'drive_by'")
  end
end
