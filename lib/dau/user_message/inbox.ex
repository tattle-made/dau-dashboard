defmodule DAU.UserMessage.Inbox do
  alias DAU.UserMessage.Inbox
  alias DAU.UserMessage.Query
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          id: integer,
          media_type: String.t(),
          sender_number: String.t(),
          sender_name: String.t(),
          user_language_input: :en | :hi | :ta | :te | :und,
          user_input_text: String.t(),
          caption: String.t(),
          file_key: String.t(),
          file_hash: String.t(),
          content_id: String.t()
        }

  @derive Jason.Encoder
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
    field :content_id, :string
    belongs_to :query, Query
    timestamps(type: :utc_datetime)
  end

  def changeset(incoming_message, attrs \\ %{}) do
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

  def changeset_with_date(incoming_message, attrs) do
    incoming_message
    |> cast(attrs, [
      :media_type,
      :path,
      :sender_number,
      :sender_name,
      :user_language_input,
      :user_input_text,
      :caption,
      :inserted_at,
      :updated_at,
      :content_id
    ])
    # |> validate_required([:source, :payload_id, :payload_type, :sender_phone, :sender_name, :context_id, :context_gsid, :payload_text, :payload_caption, :payload_url, :payload_contenttype])
    |> validate_required([
      :media_type,
      :path,
      :sender_number,
      :sender_name,
      :inserted_at,
      :updated_at
    ])
  end

  def file_metadata_changeset(user_message_inbox, attrs) do
    user_message_inbox
    |> cast(attrs, [:file_key, :file_hash])
    |> validate_required([:file_key, :file_hash])
  end

  def text_file_hash_changeset(user_message_inbox, attrs) do
    user_message_inbox
    |> cast(attrs, [:file_hash])
    |> validate_required([:file_hash])
  end

  def associate_query_changeset(user_message_inbox, query) do
    Inbox.changeset(user_message_inbox)
    |> put_assoc(:query, query)
  end
end
