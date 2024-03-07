defmodule DAU.Feed.Common do
  use Ecto.Schema
  import Ecto.Changeset

  schema "feed_common" do
    field :status, Ecto.Enum, values: [:published, :in_progress, :not_taken]
    field :media_urls, {:array, :string}
    field :verification_note, :string
    field :tags, {:array, :string}
    field :exact_count, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(common, attrs) do
    common
    |> cast(attrs, [:media_urls, :verification_note, :tags, :status, :exact_count])
    |> validate_required([:media_urls])
  end
end
