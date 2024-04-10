defmodule DAU.UserMessage.Outbox do
  alias DAU.Accounts.User
  use Ecto.Schema
  import Ecto.Changeset
  alias DAU.UserMessage.Outbox

  @primary_key {:id, Ecto.UUID, autogenerate: true}

  schema "user_message_outbox" do
    field :sender_number, :string
    field :sender_name, :string
    field :reply_type, Ecto.Enum, values: [:customer_reply, :notification]
    field :type, Ecto.Enum, values: [:text, :json]
    field :text, :string
    field :message, :map
    belongs_to :approver, User, foreign_key: :approved_by
    field :approval_status, Ecto.Enum, values: [:ok, :pause, :cancel]
    field :delivery_status, Ecto.Enum, values: [:success, :error, :unknown]
    field :delivery_report, :string
    field :e_id, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(outbox_message, attrs) do
    outbox_message
    |> cast(attrs, [
      :sender_number,
      :sender_name,
      :reply_type,
      :type,
      :text,
      :message,
      :e_id
    ])
    |> validate_required([
      :sender_number,
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

      :json ->
        changeset |> validate_required([:message])

      _ ->
        changeset |> add_error(:type, "Unsupported message type")
    end
  end

  def delivery_report_changeset(%Outbox{} = outbox, delivery_report \\ %{}) do
    outbox
    |> cast(delivery_report, [:delivery_status, :delivery_report])
    |> validate_required([:delivery_status, :delivery_report])
    |> slice_report_to_fit_field_length
  end

  defp slice_report_to_fit_field_length(changeset) do
    full_report = get_field(changeset, :delivery_report)
    sliced_report = String.slice(full_report, 0..254)
    changeset = put_change(changeset, :delivery_report, sliced_report)

    changeset
  end

  def approver_changeset(%Outbox{} = outbox, %User{} = user) do
    outbox
    |> change
    |> put_assoc(:approver, user)
  end
end
