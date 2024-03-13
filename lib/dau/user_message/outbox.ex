defmodule DAU.UserMessage.Outbox do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_message_inbox" do
    field :context_id, :string
    field :context_gsid, :string
    field :payload_text, :string
    field :payload_caption, :string
    field :payload_url, :string
    field :payload_contenttype, :string
    field :payload_type, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(outgoing_message, attrs) do
    outgoing_message
    |> cast(attrs, [
      :context_id,
      :context_gsid,
      :payload_text,
      :payload_caption,
      :payload_url,
      :payload_contenttype,
      :payload_type
    ])
    |> validate_required([
      :context_id,
      :context_gsid,
      :payload_text,
      :payload_caption,
      :payload_url,
      :payload_contenttype,
      :payload_type
    ])
  end
end
