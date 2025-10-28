defmodule DAU.Slack.File do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :file_id, :string
    field :title, :string
    field :mimetype, :string
    field :filetype, :string
    field :url_private, :string
    field :permalink, :string
    field :url_private_download, :string
  end

  def changeset(file, params) do
    file
    |> cast(params, [
      :file_id,
      :title,
      :mimetype,
      :filetype,
      :url_private,
      :permalink,
      :url_private_download
    ])
    |> validate_required([:file_id, :permalink])
  end
end
