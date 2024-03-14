defmodule DAU.UserMessage.Inbox do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_message_inbox" do
    field :sender_number, :string
    field :sender_name, :string
    field :media_type, :string
    field :path, :string
    field :file_key, :string
    field :file_hash, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(incoming_message, attrs) do
    incoming_message
    |> cast(attrs, [
      :sender_number,
      :sender_name,
      :media_type,
      :path
    ])
    # |> validate_required([:source, :payload_id, :payload_type, :sender_phone, :sender_name, :context_id, :context_gsid, :payload_text, :payload_caption, :payload_url, :payload_contenttype])
    |> validate_required([
      :sender_number,
      :sender_name,
      :media_type,
      :path
    ])
  end

  def file_metadata_changeset(user_message_inbox, attrs) do
    user_message_inbox
    |> cast(attrs, [:file_key, :file_hash])
    |> validate_required([:file_key, :file_hash])
  end
end
