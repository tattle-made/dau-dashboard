[
  import_deps: [:ecto, :ecto_sql, :phoenix, :oban_web],
  subdirectories: ["priv/*/migrations"],
  plugins: [Phoenix.LiveView.HTMLFormatter],
  inputs: ["*.{heex,ex,exs}", "{config,lib,test}/**/*.{heex,ex,exs}", "priv/*/*.exs"]
]
