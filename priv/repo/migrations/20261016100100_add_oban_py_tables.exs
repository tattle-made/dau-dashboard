defmodule DAU.Repo.Migrations.AddObanPyTables do
  use Ecto.Migration

  # Copied from oban-py 0.6.6 oban/queries/install.sql:
  # https://github.com/oban-bg/oban-py/blob/5632a8856cb26ae1310717edfc7d1eca584010e8/oban/queries/install.sql
  # oban_leaders is oban-py's leader-lease table; Elixir Oban uses oban_peers for the same job.
  # They are separate, so each language would elect its own leader. oban-py runs with
  # leadership = false, so oban_leaders stays empty. It exists only because oban-py refuses
  # to start without it.

  def up do
    execute """
    CREATE UNLOGGED TABLE IF NOT EXISTS oban_leaders (
        name text PRIMARY KEY DEFAULT 'oban',
        node text NOT NULL,
        elected_at timestamp WITHOUT TIME ZONE NOT NULL,
        expires_at timestamp WITHOUT TIME ZONE NOT NULL
    )
    """

    execute """
    CREATE UNLOGGED TABLE IF NOT EXISTS oban_producers (
        uuid uuid PRIMARY KEY,
        name text NOT NULL DEFAULT 'oban',
        node text NOT NULL,
        queue text NOT NULL,
        meta jsonb NOT NULL DEFAULT '{}',
        started_at timestamp WITHOUT TIME ZONE NOT NULL DEFAULT timezone('UTC', now()),
        updated_at timestamp WITHOUT TIME ZONE NOT NULL DEFAULT timezone('UTC', now())
    )
    """
  end

  def down do
    execute "DROP TABLE IF EXISTS oban_producers"
    execute "DROP TABLE IF EXISTS oban_leaders"
  end
end
