defmodule DAU.UserMessage.Preference do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_message_preferences" do
    field :language, :string
    field :sender_number, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(preference, attrs) do
    preference
    |> cast(attrs, [:language, :sender_number])
    |> validate_required([:language, :sender_number])
  end

  def phone_changeset(preference, attrs \\ %{}) do
    preference
    |> cast(attrs, [:sender_number])
    |> validate_required([:sender_number])
  end
end
