defmodule DAU.Canon.ManipulatedMedia do
  use Ecto.Schema
  import Ecto.Changeset

  schema "manipulated_media" do
    field :description, :string
    field :url, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(manipulated_media, attrs) do
    manipulated_media
    |> cast(attrs, [:description, :url])
    |> validate_required([:description, :url])
  end
end
