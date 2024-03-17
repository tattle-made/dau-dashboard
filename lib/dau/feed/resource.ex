defmodule DAU.Feed.Resource do
  alias DAU.Feed.Resource
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :username, :string
    field :type, Ecto.Enum, values: [:video, :audio, :image, :text]
    field :text, :string
    field :media_url, :string
  end

  def changeset(%Resource{} = resource, attrs \\ %{}) do
    resource
    |> cast(attrs, [:username, :text, :type, :media_url])
    |> validate_required([:username])
  end
end
