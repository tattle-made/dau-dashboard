# Contributing to DAU Dashboard

Thanks for your interest in contributing to DAU Dashboard. We welcome contributions of all kinds, including code, documentation, design, and discussion.

This guide will help you set up a local development environment for the dashboard and its media hash worker.

## How the pieces fit

| Piece | Repo | What it does |
| --- | --- | --- |
| Dashboard | this repo (Phoenix, Elixir) | Web app, business logic, database schema. Runs Elixir Oban for background jobs. |
| Hash worker | [`dau-worker`](https://github.com/tattle-made/dau-worker) (Python) | Hashes media files. Runs [oban-py](https://github.com/oban-bg/oban-py). |
| Postgres | `docker-compose.dev.yml` | Shared by both. |

The dashboard queues media hashing jobs and the worker runs them; both share one Postgres.
How the pipeline works, and how it's configured, is in [DEPLOYMENT.md](DEPLOYMENT.md).

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/), with Docker Compose
- [Elixir](https://elixir-lang.org/install.html) 1.18.3 and Erlang/OTP 27 (pinned in `.tool-versions`; `asdf install` picks them up)
- [Node.js](https://nodejs.org/) and npm (frontend assets)
- [Python 3.12+](https://www.python.org/downloads/) and [`uv`](https://docs.astral.sh/uv/) (hash worker)
- [AWS CLI](https://aws.amazon.com/cli/) and [`jq`](https://jqlang.org/) (to fetch credentials)
- [Git](https://git-scm.com/)

## Setup Steps

1. **Clone both repositories side by side:**

   ```sh
   git clone https://github.com/tattle-made/dau-dashboard.git
   git clone https://github.com/tattle-made/dau-worker.git
   cd dau-dashboard
   ```

2. **Fetch credentials:**

   Credentials are stored in AWS Secrets Manager. Ask @dennyabrain for the `SECRET_ARN` and
   credentials for a suitable AWS IAM account:

   ```sh
   aws secretsmanager get-secret-value --secret-id $SECRET_ARN | jq '.SecretString' | jq -r | jq -r 'to_entries[]' | jq -r '"export " + .key + "=" + .value' > env.dev
   ```

   Tests use an offline fake (`AWSS3.Fake`), so dummy AWS values are enough there.

3. **Start Postgres:**

   ```sh
   docker compose -f docker-compose.dev.yml up -d
   ```

   This starts Postgres and Adminer only. To run everything in containers instead, see
   [Running Everything in Docker](#running-everything-in-docker).

   Adminer runs at [localhost:8080](http://localhost:8080):

   | | |
   |---|---|
   | System | PostgreSQL |
   | Server | db |
   | Username | tattle |
   | Password | weak_password |

4. **Set up the dashboard:**

   ```sh
   source env.dev
   cd assets && npm install && cd ..
   mix setup
   ```

   `mix setup` installs dependencies, creates and migrates the db, seeds it, and builds assets.
   The seeds create one user per role (`priv/repo/seeds.exs`).

   After pulling new code, run `mix ecto.migrate`.

5. **Set up the hash worker:**

   ```sh
   cd ../dau-worker
   uv sync
   cp .env.example .env
   # Fill in .env
   cd ../dau-dashboard
   ```

6. **Start the dashboard**

   From `dau-dashboard`:

   ```sh
   source env.dev
   mix phx.server
   ```

   Use `iex -S mix phx.server` for a shell inside the running app.

2. **Start the hash worker**

   From `dau-worker`:

   ```sh
   uv run --env-file .env oban start
   ```

   `--env-file` loads `.env` in any shell, fish included.

> **Tip:** Never run `oban install` or `oban uninstall` in the worker. The dashboard's migrations
> own the schema, and `uninstall` would also drop the dashboard's jobs.

To queue a hash by hand and inspect jobs, see
[DEPLOYMENT.md: Inspecting and Running Jobs](DEPLOYMENT.md#inspecting-and-running-jobs).

## Running Everything in Docker

`docker-compose.standalone.yml` runs Postgres, Adminer, the dashboard and the hash worker in
containers. The dashboard runs as a production release, so there is no live reload. Use it to
try DAU without installing Elixir or Python.

1. Create `env.docker` from `env.dev`, without the `export` keywords, and add a
   `SECRET_KEY_BASE` (generate one with `openssl rand -base64 48`).
2. Export the worker's AWS credentials in your shell:

   ```sh
   export AWS_ACCESS_KEY_ID_HASH_WORKER=...
   export AWS_SECRET_ACCESS_KEY_HASH_WORKER=...
   ```

3. From `dau-dashboard`, with `dau-worker` checked out next to it:

   ```sh
   docker compose -f docker-compose.standalone.yml up -d --build
   ```

## Running the Tests

1. **Dashboard**

   From `dau-dashboard`:

   ```sh
   source env.dev
   mix test
   ```

2. **Hash worker**

   From `dau-worker`:

   ```sh
   uv run --env-file .env pytest
   ```

## Other Tasks

- **Docs:** `mix docs` writes HTML and EPUB to `doc/`.
- **Media during development:** files in `priv/static/assets/media` are served at
  `http://localhost:4000/assets/media/<filename>`.
- **Test media:** the project's S3 bucket has test files under the `temp` prefix (for example
  `temp/audio-01.wav`, `temp/video-01.mp4`). To upload more: `aws s3 sync . s3://staging.dau.tattle.co.in/temp`.
- **Reseed:** `mix run priv/repo/seeds.exs`, or `mix ecto.reset` to drop and rebuild `dau_dev`.

## Additional Resources

- [DEPLOYMENT.md](DEPLOYMENT.md): how the system runs, the hashing pipeline, configuration
- [dau-worker](https://github.com/tattle-made/dau-worker): the media hash worker
- [Oban (Elixir)](https://hexdocs.pm/oban/Oban.html) and [oban-py](https://github.com/oban-bg/oban-py)
- [feluda](https://github.com/tattle-made/feluda): media analysis library behind the worker's hashing
