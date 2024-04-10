import Config

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
# The block below contains prod specific runtime configuration.

# ## Using releases
#
# If you use `mix release`, you need to explicitly enable the server
# by passing the PHX_SERVER=true when you start it:
#
#     PHX_SERVER=true bin/dau start
#
# Alternatively, you can use `mix phx.gen.release` to generate a `bin/server`
# script that automatically sets the env var above.
if System.get_env("PHX_SERVER") do
  config :dau, DAUWeb.Endpoint, server: true
end

aws_access_key_id =
  System.get_env("AWS_ACCESS_KEY_ID") ||
    raise """
    aws access key is missing. Please contact tattle admin.
    """

aws_secret_access_key =
  System.get_env("AWS_SECRET_ACCESS_KEY") ||
    raise """
    aws secret acess key are missing. Please contact tattle admin.
    """

gupshup_api_endpoint =
  System.get_env("GUPSHUP_ENDPOINT") ||
    raise """
    Gupshup api endpoint is missing. Please contact tattle admin
    """

gupshup_userid =
  System.get_env("GUPSHUP_USERID") ||
    raise """
    Gupshup user id is missing. Please contact tattle admin.
    """

gupshup_password =
  System.get_env("GUPSHUP_PASSWORD") ||
    raise """
    Gupshup password is missing. Please contact tattle admin
    """

gupshup_hsm_userid =
  System.get_env("GUPSHUP_HSM_USERID") ||
    raise """
    Gupshup HSM user id is missing. Please contact tattle admin.
    """

gupshup_hsm_password =
  System.get_env("GUPSHUP_HSM_PASSWORD") ||
    raise """
    Gupshup HSM password is missing. Please contact tattle admin
    """

slack_webhook_url =
  System.get_env("SLACK_WEBHOOK_URL") ||
    raise """
    Slack webhook url is missing. Please contact tattle admin
    """

config :dau,
  aws_access_key_id: aws_access_key_id,
  aws_secret_access_key: aws_secret_access_key,
  gupshup_api_endpoint: gupshup_api_endpoint,
  gupshup_userid: gupshup_userid,
  gupshup_password: gupshup_password,
  gupshup_hsm_userid: gupshup_hsm_userid,
  gupshup_hsm_password: gupshup_hsm_password,
  slack_webhook_url: slack_webhook_url

config :ex_aws,
  region: "ap-south-1",
  access_key_id: {:system, "AWS_ACCESS_KEY_ID"},
  secret_access_key: {:system, "AWS_SECRET_ACCESS_KEY"}

if config_env() == :prod do
  # database_url =
  #   System.get_env("DATABASE_URL") ||
  #     raise """
  #     environment variable DATABASE_URL is missing.
  #     For example: ecto://USER:PASS@HOST/DATABASE
  #     """

  maybe_ipv6 = if System.get_env("ECTO_IPV6") in ~w(true 1), do: [:inet6], else: []

  config :dau, DAU.Repo,
    # ssl: true,
    # url: database_url,
    username: System.get_env("DATABASE_USER"),
    password: System.get_env("DATABASE_PASSWORD"),
    hostname: System.get_env("DATABASE_HOSTNAME"),
    database: System.get_env("DATABASE_NAME"),
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    socket_options: maybe_ipv6,
    stacktrace: true

  # The secret key base is used to sign/encrypt cookies and other secrets.
  # A default value is used in config/dev.exs and config/test.exs but you
  # want to use a different value for prod and you most likely don't want
  # to check this value into version control, so we use an environment
  # variable instead.
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  host = System.get_env("PHX_HOST") || "dau.tattle.co.in"
  port = String.to_integer(System.get_env("PORT") || "4000")

  config :dau, :dns_cluster_query, System.get_env("DNS_CLUSTER_QUERY")

  config :dau, DAUWeb.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    server: true,
    http: [
      # Enable IPv6 and bind on all interfaces.
      # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
      # See the documentation on https://hexdocs.pm/plug_cowboy/Plug.Cowboy.html
      # for details about using IPv6 vs IPv4 and loopback vs public addresses.
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base

  # ## SSL Support
  #
  # To get SSL working, you will need to add the `https` key
  # to your endpoint configuration:
  #
  #     config :dau, DAUWeb.Endpoint,
  #       https: [
  #         ...,
  #         port: 443,
  #         cipher_suite: :strong,
  #         keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
  #         certfile: System.get_env("SOME_APP_SSL_CERT_PATH")
  #       ]
  #
  # The `cipher_suite` is set to `:strong` to support only the
  # latest and more secure SSL ciphers. This means old browsers
  # and clients may not be supported. You can set it to
  # `:compatible` for wider support.
  #
  # `:keyfile` and `:certfile` expect an absolute path to the key
  # and cert in disk or a relative path inside priv, for example
  # "priv/ssl/server.key". For all supported SSL configuration
  # options, see https://hexdocs.pm/plug/Plug.SSL.html#configure/1
  #
  # We also recommend setting `force_ssl` in your endpoint, ensuring
  # no data is ever sent via http, always redirecting to https:
  #
  #     config :dau, DAUWeb.Endpoint,
  #       force_ssl: [hsts: true]
  #
  # Check `Plug.SSL` for all available options in `force_ssl`.

  # ## Configuring the mailer
  #
  # In production you need to configure the mailer to use a different adapter.
  # Also, you may need to configure the Swoosh API client of your choice if you
  # are not using SMTP. Here is an example of the configuration:
  #
  #     config :dau, DAU.Mailer,
  #       adapter: Swoosh.Adapters.Mailgun,
  #       api_key: System.get_env("MAILGUN_API_KEY"),
  #       domain: System.get_env("MAILGUN_DOMAIN")
  #
  # For this example you need include a HTTP client required by Swoosh API client.
  # Swoosh supports Hackney and Finch out of the box:
  #
  #     config :swoosh, :api_client, Swoosh.ApiClient.Hackney
  #
  # See https://hexdocs.pm/swoosh/Swoosh.html#module-installation for details.
end
