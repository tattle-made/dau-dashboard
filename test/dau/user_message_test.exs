defmodule DAU.UserMessageTest do
  use DAU.DataCase

  alias DAU.UserMessage

  describe "incoming_messages" do
    alias DAU.UserMessage.IncomingMessage

    import DAU.UserMessageFixtures

    @invalid_attrs %{
      source: nil,
      payload_id: nil,
      payload_type: nil,
      sender_phone: nil,
      sender_name: nil,
      context_id: nil,
      context_gsid: nil,
      payload_text: nil,
      payload_caption: nil,
      payload_url: nil,
      payload_contenttype: nil
    }

    test "list_incoming_messages/0 returns all incoming_messages" do
      incoming_message = incoming_message_fixture()
      assert UserMessage.list_incoming_messages() == [incoming_message]
    end

    test "get_incoming_message!/1 returns the incoming_message with given id" do
      incoming_message = incoming_message_fixture()
      assert UserMessage.get_incoming_message!(incoming_message.id) == incoming_message
    end

    test "create_incoming_message/1 with valid data creates a incoming_message" do
      valid_attrs = %{
        source: "some source",
        payload_id: "some payload_id",
        payload_type: "some payload_type",
        sender_phone: "some sender_phone",
        sender_name: "some sender_name",
        context_id: "some context_id",
        context_gsid: "some context_gsid",
        payload_text: "some payload_text",
        payload_caption: "some payload_caption",
        payload_url: "some payload_url",
        payload_contenttype: "some payload_contenttype"
      }

      assert {:ok, %IncomingMessage{} = incoming_message} =
               UserMessage.create_incoming_message(valid_attrs)

      assert incoming_message.source == "some source"
      assert incoming_message.payload_id == "some payload_id"
      assert incoming_message.payload_type == "some payload_type"
      assert incoming_message.sender_phone == "some sender_phone"
      assert incoming_message.sender_name == "some sender_name"
      assert incoming_message.context_id == "some context_id"
      assert incoming_message.context_gsid == "some context_gsid"
      assert incoming_message.payload_text == "some payload_text"
      assert incoming_message.payload_caption == "some payload_caption"
      assert incoming_message.payload_url == "some payload_url"
      assert incoming_message.payload_contenttype == "some payload_contenttype"
    end

    test "create_incoming_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserMessage.create_incoming_message(@invalid_attrs)
    end

    test "update_incoming_message/2 with valid data updates the incoming_message" do
      incoming_message = incoming_message_fixture()

      update_attrs = %{
        source: "some updated source",
        payload_id: "some updated payload_id",
        payload_type: "some updated payload_type",
        sender_phone: "some updated sender_phone",
        sender_name: "some updated sender_name",
        context_id: "some updated context_id",
        context_gsid: "some updated context_gsid",
        payload_text: "some updated payload_text",
        payload_caption: "some updated payload_caption",
        payload_url: "some updated payload_url",
        payload_contenttype: "some updated payload_contenttype"
      }

      assert {:ok, %IncomingMessage{} = incoming_message} =
               UserMessage.update_incoming_message(incoming_message, update_attrs)

      assert incoming_message.source == "some updated source"
      assert incoming_message.payload_id == "some updated payload_id"
      assert incoming_message.payload_type == "some updated payload_type"
      assert incoming_message.sender_phone == "some updated sender_phone"
      assert incoming_message.sender_name == "some updated sender_name"
      assert incoming_message.context_id == "some updated context_id"
      assert incoming_message.context_gsid == "some updated context_gsid"
      assert incoming_message.payload_text == "some updated payload_text"
      assert incoming_message.payload_caption == "some updated payload_caption"
      assert incoming_message.payload_url == "some updated payload_url"
      assert incoming_message.payload_contenttype == "some updated payload_contenttype"
    end

    test "update_incoming_message/2 with invalid data returns error changeset" do
      incoming_message = incoming_message_fixture()

      assert {:error, %Ecto.Changeset{}} =
               UserMessage.update_incoming_message(incoming_message, @invalid_attrs)

      assert incoming_message == UserMessage.get_incoming_message!(incoming_message.id)
    end

    test "delete_incoming_message/1 deletes the incoming_message" do
      incoming_message = incoming_message_fixture()
      assert {:ok, %IncomingMessage{}} = UserMessage.delete_incoming_message(incoming_message)

      assert_raise Ecto.NoResultsError, fn ->
        UserMessage.get_incoming_message!(incoming_message.id)
      end
    end

    test "change_incoming_message/1 returns a incoming_message changeset" do
      incoming_message = incoming_message_fixture()
      assert %Ecto.Changeset{} = UserMessage.change_incoming_message(incoming_message)
    end
  end
end
