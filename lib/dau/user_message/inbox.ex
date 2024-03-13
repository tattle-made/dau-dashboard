defmodule DAU.UserMessage.Inbox do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_message_inbox" do
    field :mobile, :string
    field :name, :string
    field :type, :string
    field :timestamp, :string
    field :audio, :string
    field :video, :string
    field :image, :string
    field :text, :string
    field :file_key, :string
    field :file_hash, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(incoming_message, attrs) do
    incoming_message
    |> cast(attrs, [
      :mobile,
      :name,
      :type,
      :timestamp,
      :audio,
      :video,
      :image,
      :text
    ])
    # |> validate_required([:source, :payload_id, :payload_type, :sender_phone, :sender_name, :context_id, :context_gsid, :payload_text, :payload_caption, :payload_url, :payload_contenttype])
    |> validate_required([
      :mobile,
      :name,
      :type,
      :timestamp
    ])
    |> validate_by_type()
  end

  def file_metadata_changeset(user_message_inbox, attrs) do
    user_message_inbox
    |> cast(attrs, [:file_key, :file_hash])
    |> validate_required([:file_key, :file_hash])
  end

  defp validate_by_type(changeset) do
    case get_field(changeset, :type) do
      :text ->
        changeset
        |> validate_required([:text], "type value is text but it does not have a text field")

      :image ->
        changeset
        |> validate_required([:image], "type value is image but it does not have an image field")

      :video ->
        changeset
        |> validate_required(
          [:video],
          "type value is video but changeset does not have a video field"
        )

      :audio ->
        changeset
        |> validate_required(
          [:audio],
          "type value is audio but changeset does not have an audio field"
        )

      _ ->
        changeset
    end
  end
end
