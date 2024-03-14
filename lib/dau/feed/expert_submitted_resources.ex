defmodule DAU.Feed.ExpertSubmittedResources do
  use Ecto.Schema
  import Ecto.Changeset

  schema "feed_expert_submitted_resources" do
    field :text, :string
    field :feed_id, :id
    field :user, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(expert_submitted_resources, attrs) do
    expert_submitted_resources
    |> cast(attrs, [:text])
    |> validate_required([:text])
  end
end
