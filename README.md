# DAU Dashboard
Deepfake Analysis Unit(DAU) is a collaborative space for analyzing deepfakes 

## Developing Locally

### Prerequisites
1. docker : 24.0.5
2. aws cli : 2.2.25
3. jq : 1.6
4. elixir : 1.15.0
5. Erlang/OTP : 26.0 

### 1. Setup infrastructure dependencies**

- Run `source env.dev` to setup enviroment variables.
- `docker-compose up`
Visit `localhost:8080` to access adminer. Login with following fields

| | |
|---|---|
|System|PostgreSQL|
|Server|db|
|Username|tattle|
|Password|weak_password|

### 2. Fetch Credentials
Credentials are stored using AWS Secrets Manager. Please request @dennyabrain for SECRET_ARN and credentials for a suitable AWS IAM account
```shell
aws secretsmanager get-secret-value --secret-id $SECRET_ARN | jq '.SecretString' | jq -r | jq -r 'to_entries[]' | jq -r '"export " + .key + "=" + .value' > env.dev
```

### 3. Setup and Start your Phoenix server

1. Load environment variables : `source env.dev` 
2. Install frontend Dependencies : `cd assets && npm install` 
3. To start your Phoenix server, first Run `mix setup` to install and setup dependencies.
4. Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Viewing Documentation
Run `mix docs`. This generates the documentation and puts the .html and .epub file in `doc/`. Run `http-server doc/` and visit [`localhost:80801`](http://localhost:8081) 


### Media during development
Copy Paste files in `/priv/static/assets/media`. These will be available to the app at `http://localhost:4000/assets/media/${filename.extention}`

#### Test media files
Since this app relies on media files so heavily, we have added some test files in the project specific s3 bucket. These are available with the prefix `temp`. Some example files are `temp/audio-01.wav` and `temp/video-01.mp4`. These are used throughout unit tests and integration tests. There are 10 audio files and 50 video files. 

### Seeding Data 
1. Upload test files to s3 : `aws s3 sync . s3://staging.dau.tattle.co.in/temp`
2. Seed database : `mix run priv/repo/seeds.exs`

