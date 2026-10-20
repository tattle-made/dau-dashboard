# Deployment

How DAU runs: its components, the media hashing pipeline, start-up order, configuration, and how
to inspect jobs. For a local development setup, see [CONTRIBUTING.md](CONTRIBUTING.md).

## Components

| Component | Source | Runs |
| --- | --- | --- |
| Dashboard | this repo | Phoenix release. The `Dockerfile` builds it; `.github/workflows/release.yml` publishes `tattletech/dau-dashboard`. Starts with `bin/dau start`. |
| Hash worker | [`dau-worker`](https://github.com/tattle-made/dau-worker) | oban-py worker. Its `Dockerfile` builds the image; it starts with `oban start`. |
| Postgres | 14+ (13 is the minimum for oban-py) | Shared by both. Holds the app tables and the Oban job tables. |

## Media Hashing

Media hashing works through two job queues in the `oban_jobs` table, managed by
[Oban](https://hexdocs.pm/oban/Oban.html) on the dashboard side and
[oban-py](https://github.com/oban-bg/oban-py) on the worker side:

1. The dashboard inserts a `media_hash` job (`DAU.MediaMatch.create_job(inbox, :hash_worker)`).
2. The worker downloads the file from S3, hashes it (feluda's `MediaHash`, blake2b of the file),
   and inserts a `media_results` job.
3. The dashboard's `DAU.MediaMatch.HashResultWorker` saves the hash, updates the duplicate count,
   and auto-tags spam.

The dashboard owns the database schema: all tables, including the worker's Oban tables
(`oban_leaders`, `oban_producers`), come from the dashboard's Ecto migrations. The worker never
changes the schema.

> **Never run `oban install` or `oban uninstall` against this database.** The migrations own the
> schema, and `uninstall` would also drop the dashboard's jobs.

Only the dashboard does job maintenance (pruning old jobs, rescuing stuck ones). The worker runs
with `leadership = false` in its `oban.toml`, so it only runs jobs.

## Start-up Order

1. **Postgres.**
2. **Migrations.** The dashboard image's `CMD` does not migrate. Run them before starting the
   release:

   ```sh
   bin/dau eval "DAU.Release.migrate()"
   ```

3. **Dashboard:** `bin/dau start`.
4. **Hash worker(s).** A worker refuses to start until the Oban tables exist, so it must come
   after step 2. Run more worker containers to hash more files in parallel.

## Environment

**Dashboard** (`config/runtime.exs`):

- Always required: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `GUPSHUP_ENDPOINT`,
  `GUPSHUP_USERID`, `GUPSHUP_PASSWORD`, `GUPSHUP_HSM_USERID`, `GUPSHUP_HSM_PASSWORD`,
  `SLACK_WEBHOOK_URL`.
- Production: `SECRET_KEY_BASE` (required), `DATABASE_USER`, `DATABASE_PASSWORD`,
  `DATABASE_HOSTNAME`, `DATABASE_NAME`, `POOL_SIZE` (default 10), `PHX_HOST`
  (default `dau.tattle.co.in`), `PORT` (default 4000), `PHX_SERVER`.

**Hash worker** (see `dau-worker/.env.example`):

- `OBAN_DSN`: the dashboard's database.
- `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`, `AWS_BUCKET`: read-only access to the
  bucket the dashboard uploads to (`staging.dau.tattle.co.in`). feluda reads these when it is
  first imported, so they must be set before the worker starts.

## Configuration

| Setting | Where |
| --- | --- |
| Elixir Oban queues and concurrency (`media_results: 5`) | `config/config.exs` |
| Job retention (30 days) and stuck-job rescue (30 min) | `config/config.exs` (`pruner`, `lifeline`) |
| Hash job queue, worker name, retries (`max_attempts: 5`) | `lib/dau/media_match.ex` |
| Result handling | `lib/dau/media_match/hash_result_worker.ex`, `lib/dau/media_match/blake2b.ex` |
| Worker queue and concurrency (`media_hash = 2`, per worker process) | `dau-worker/oban.toml`, or `OBAN_QUEUES=media_hash:4` |
| Worker hashers and 20 min hash timeout | `dau-worker/dau_worker/hashers.py`, `dau-worker/dau_worker/contract.py` |

The hash timeout (20 min) must stay below the stuck-job rescue (30 min), so the dashboard only
rescues jobs whose worker died, never jobs that are still running.

## Inspecting and Running Jobs

Queue a hash for an audio or video inbox item from a console (`bin/dau remote` in a release,
`iex -S mix phx.server` locally):

```elixir
inbox = DAU.Repo.get!(DAU.UserMessage.Inbox, 123)
DAU.MediaMatch.create_job(inbox, :hash_worker)
```

The worker logs the job. The result shows up as a row in `hashes` for that inbox.

Look at recent jobs:

```sql
SELECT id, queue, worker, state, attempt, args, errors
FROM oban_jobs
ORDER BY id DESC
LIMIT 20;
```

- Failed attempts keep their tracebacks in `errors`. A job retries up to 5 times, then becomes
  `discarded`.
- Cancelling a running hash job is cooperative: the download and hash finish, and the worker drops
  the result.

## Shutdown

On `SIGTERM`, the worker stops fetching and waits for its running jobs to finish, with no time
limit. A container runtime that kills it sooner (Docker's default is 10 s) leaves those jobs in
`executing`; the dashboard rescues them after 30 minutes and they run again. Give the worker a
longer stop grace period than your longest expected hash. The local `docker-compose.yml` sets
`stop_grace_period: 20m`, the same as the hash timeout.
