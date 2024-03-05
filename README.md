# DAU Dashboard
Deepfake Analysis Unit(DAU) is a collaborative space for analyzing deepfakes 

## Developing Locally

### Prerequisites
1. docker : 24.0.5
2. aws cli : 2.2.25
3. jq : 1.6
4. elixir : 1.15.0
5. Erlang/OTP : 26.0 

**Setup infrastructure dependencies**

`docker-compose up`
Visit `localhost:8080` to access adminer. Login with following fields

| | |
|---|---|
|System|PostgreSQL|
|Server|db|
|Username|tattle|
|Password|weak_password|

**Fetch Credentials**
Credentials are stored using AWS Secrets Manager. Please request @dennyabrain for SECRET_ARN and credentials for a suitable AWS IAM account
```shell
aws secretsmanager get-secret-value --secret-id $SECRET_ARN | jq '.SecretString' | jq -r | jq -r 'to_entries[]' | jq -r '"export " + .key + "=" + .value' > env.dev
```

**Load environment variables** : `source env.dev` 

**Start your Phoenix server**:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Viewing Documentation
Run `mix docs`. This generates the documentation and puts the .html and .epub file in `doc/`. Run `http-server doc/` and visit [`localhost:80801`](http://localhost:8081) 


### Media during development
Copy Paste files in `/priv/static/assets/media`. These will be available to the app at `http://localhost:4000/assets/media/${filename.extention}`