defmodule DAU.Feed.Common do
  use Ecto.Schema
  import Ecto.Changeset

  schema "feed_common" do
    field :status, Ecto.Enum, values: [:published, :in_progress, :not_taken]
    field :media_urls, {:array, :string}
    field :verification_note, :string
    field :tags, {:array, :string}
    field :exact_count, :integer
    field :media_type, Ecto.Enum, values: [:video, :audio, :image, :text, :mixed]
    field :language, Ecto.Enum, values: [:en, :hi, :ta, :te, :und]
    field :taken_by, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(common, attrs) do
    common
    |> cast(attrs, [
      :media_urls,
      :media_type,
      :taken_by,
      :verification_note,
      :tags,
      :status,
      :exact_count
    ])
    |> validate_required([:media_urls, :media_type])
  end

  def annotation_changeset(common, attrs \\ %{}) do
    common
    |> cast(attrs, [:verification_note, :tags])
  end

  def take_up_changeset(common, attrs \\ %{}) do
    common
    |> cast(attrs, [:taken_by])
    |> validate_required([:taken_by])
  end
end
