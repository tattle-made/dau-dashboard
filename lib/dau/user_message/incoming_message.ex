defmodule DAU.UserMessage.IncomingMessage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "incoming_messages" do
    field :source, :string
    field :payload_id, :string
    field :payload_type, :string
    field :sender_phone, :string
    field :sender_name, :string
    field :context_id, :string
    field :context_gsid, :string
    field :payload_text, :string
    field :payload_caption, :string
    field :payload_url, :string
    field :payload_contenttype, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(incoming_message, attrs) do
    incoming_message
    |> cast(attrs, [:source, :payload_id, :payload_type, :sender_phone, :sender_name, :context_id, :context_gsid, :payload_text, :payload_caption, :payload_url, :payload_contenttype])
    |> validate_required([:source, :payload_id, :payload_type, :sender_phone, :sender_name, :context_id, :context_gsid, :payload_text, :payload_caption, :payload_url, :payload_contenttype])
  end
end
