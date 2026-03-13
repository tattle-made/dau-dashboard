defmodule DAU.OpenData.PartnerEscalation do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [
    :date,
    :media_urls,
    :count,
    :language_of_content,
    :tools_used,
    :observations,
    :remarks,
    :uuid
  ]

  schema "partner_escalations" do
    field :date, :date
    field :media_urls, {:array, :string}
    field :count, :integer
    field :language_of_content, :string
    field :tools_used, {:array, :string}
    field :observations, {:array, :string}
    field :remarks, :string
    field :uuid, Ecto.UUID

    many_to_many :tags, DAU.OpenData.Tag, join_through: DAU.OpenData.PartnerEscalationTag

    timestamps(type: :utc_datetime)
  end

  def changeset(partner_escalation, attrs \\ %{}) do
    partner_escalation
    |> cast(attrs, @fields)
    |> validate_required([:uuid])
    |> unique_constraint(:uuid, name: :partner_escalations_uuid_unique_index)
  end
end
