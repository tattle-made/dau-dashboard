defmodule DAU.UserMessage.Outbox do
  alias DAU.Accounts.User
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}

  schema "user_message_outbox" do
    field :sender_number, :string
    field :sender_name, :string
    field :reply_type, :string
    field :type, :string
    field :text, :string
    field :message, :map
    belongs_to :approved_by, User
    field :approval_status, Ecto.Enum, values: [:ok, :pause, :cancel]
    field :delivery_status, Ecto.Enum, values: [:success, :failure, :error]
    field :deliver_report, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def new_changeset(outbox_message, attrs) do
    outbox_message
    |> cast(attrs, [
      :sender_number,
      :sender_name,
      :reply_type,
      :type,
      :text,
      :message
    ])
    |> validate_required([
      :sender_number,
      :sender_name,
      :reply_type,
      :type
    ])
    |> validate_by_type
  end

  # def approval_changeset(outbox_message, attrs) do
  #   outbox_message
  #   |> cast(attrs, [:approval_status])
  #   |> cast_assoc(:approved_by, )
  # end

  defp validate_by_type(changeset) do
    case get_field(changeset, :type) do
      :text ->
        changeset |> validate_required([:text])

      :map ->
        changeset |> validate_required([:message])

      _ ->
        changeset |> add_error(:type, "Unsupported message type")
    end
  end
end
