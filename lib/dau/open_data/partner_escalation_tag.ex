defmodule DAU.OpenData.PartnerEscalationTag do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "partner_escalation_tags" do
    belongs_to :partner_escalation, DAU.OpenData.PartnerEscalation
    belongs_to :tag, DAU.OpenData.Tag

    timestamps(type: :utc_datetime)
  end

  def changeset(partner_escalation_tag, attrs) do
    partner_escalation_tag
    |> cast(attrs, [:partner_escalation_id, :tag_id])
    |> validate_required([:partner_escalation_id, :tag_id])
    |> assoc_constraint(:partner_escalation)
    |> assoc_constraint(:tag)
    |> unique_constraint([:partner_escalation_id, :tag_id],
      name: :partner_escalation_tags_unique_index
    )
  end
end
