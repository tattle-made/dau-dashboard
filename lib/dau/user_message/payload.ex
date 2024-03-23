defmodule DAU.UserMessage.Payload do
  alias DAU.UserMessage.Payload.SenderObj
  alias DAU.UserMessage.Payload.MessageObj
  alias DAU.UserMessage.Payload.ContextObj
  alias DAU.UserMessage.Payload
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :botname, :string
    field :channel, :string

    embeds_one :contextobj, ContextObj do
      field :botname, :string
      field :channeltype, :string
      field :contextid, :string
      field :senderName, :string
      field :sourceId, :string
    end

    embeds_one :messageobj, MessageObj do
      field :from, :string
      field :type, :string
      field :mediaId, :string
      field :text, :string
      field :url, :string
    end

    embeds_one :senderobj, SenderObj do
      field :channelid, :string
      field :channeltype, :string
      field :display, :string
    end
  end

  def changeset(%Payload{} = payload, attrs \\ %{}) do
    payload
    |> cast(attrs, [:botname, :channel])
    |> cast_embed(:contextobj, required: true, with: &contextobj_changeset/2)
    |> cast_embed(:messageobj, required: true, with: &messageobj_changeset/2)
    |> cast_embed(:senderobj, required: true, with: &senderobj_changeset/2)
  end

  def contextobj_changeset(%ContextObj{} = contextobj, attrs \\ %{}) do
    contextobj
    |> cast(attrs, [:botname, :channeltype])
  end

  def messageobj_changeset(%MessageObj{} = messageobj, attrs \\ %{}) do
    messageobj
    |> cast(attrs, [:id, :from, :type, :text, :url])
    |> validate_required([:id, :from, :type])
    |> validate_by_type()
  end

  defp validate_by_type(changeset) do
    case get_field(changeset, :type) do
      "text" ->
        changeset |> validate_required([:text])

      "video" ->
        changeset |> validate_required([:url])

      "audio" ->
        changeset |> validate_required([:url])

      _ ->
        changeset |> add_error(:type, "Unsupported message type")
    end
  end

  def senderobj_changeset(%SenderObj{} = senderobj, attrs \\ %{}) do
    senderobj
    |> cast(attrs, [:channelid, :channeltype, :display])
  end
end
