defmodule DAU.UserMessage.Inbox do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_message_inbox" do
    field :media_type, :string
    field :path, :string
    field :sender_number, :string
    field :sender_name, :string
    field :user_language_input, Ecto.Enum, values: [:en, :hi, :ta, :te, :und]
    field :user_input_text, :string
    field :caption, :string
    field :file_key, :string
    field :file_hash, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(incoming_message, attrs) do
    incoming_message
    |> cast(attrs, [
      :media_type,
      :path,
      :sender_number,
      :sender_name,
      :user_language_input,
      :user_input_text,
      :caption
    ])
    # |> validate_required([:source, :payload_id, :payload_type, :sender_phone, :sender_name, :context_id, :context_gsid, :payload_text, :payload_caption, :payload_url, :payload_contenttype])
    |> validate_required([
      :media_type,
      :path,
      :sender_number,
      :sender_name
    ])
  end

  def file_metadata_changeset(user_message_inbox, attrs) do
    user_message_inbox
    |> cast(attrs, [:file_key, :file_hash])
    |> validate_required([:file_key, :file_hash])
  end
end
