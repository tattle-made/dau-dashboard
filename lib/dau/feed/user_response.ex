defmodule DAU.Feed.UserResponse do
  use Ecto.Schema
  import Ecto.Changeset

  schema "feed_user_responses" do
    field :text, :string
    field :feed_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user_response, attrs) do
    user_response
    |> cast(attrs, [:text])
    |> validate_required([:text])
  end
end
