defmodule DAUWeb.IncomingMessageControllerTest do
  use DAUWeb.ConnCase

  import DAU.UserMessageFixtures

  alias DAU.UserMessage.IncomingMessage

  @create_attrs %{
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
  @update_attrs %{
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

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all incoming_messages", %{conn: conn} do
      conn = get(conn, ~p"/gupshup/message")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create incoming_message" do
    test "renders incoming_message when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/gupshup/message", incoming_message: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/gupshup/message/#{id}")

      assert %{
               "id" => ^id,
               "context_gsid" => "some context_gsid",
               "context_id" => "some context_id",
               "payload_caption" => "some payload_caption",
               "payload_contenttype" => "some payload_contenttype",
               "payload_id" => "some payload_id",
               "payload_text" => "some payload_text",
               "payload_type" => "some payload_type",
               "payload_url" => "some payload_url",
               "sender_name" => "some sender_name",
               "sender_phone" => "some sender_phone",
               "source" => "some source"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/gupshup/message", incoming_message: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update incoming_message" do
    setup [:create_incoming_message]

    test "renders incoming_message when data is valid", %{
      conn: conn,
      incoming_message: %IncomingMessage{id: id} = incoming_message
    } do
      conn = put(conn, ~p"/gupshup/message/#{incoming_message}", incoming_message: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/gupshup/message/#{id}")

      assert %{
               "id" => ^id,
               "context_gsid" => "some updated context_gsid",
               "context_id" => "some updated context_id",
               "payload_caption" => "some updated payload_caption",
               "payload_contenttype" => "some updated payload_contenttype",
               "payload_id" => "some updated payload_id",
               "payload_text" => "some updated payload_text",
               "payload_type" => "some updated payload_type",
               "payload_url" => "some updated payload_url",
               "sender_name" => "some updated sender_name",
               "sender_phone" => "some updated sender_phone",
               "source" => "some updated source"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, incoming_message: incoming_message} do
      conn = put(conn, ~p"/gupshup/message/#{incoming_message}", incoming_message: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  # Test disabled because users aren't allowed to delete incoming_messages
  # describe "delete incoming_message" do
  #   setup [:create_incoming_message]

  #   test "deletes chosen incoming_message", %{conn: conn, incoming_message: incoming_message} do
  #     conn = delete(conn, ~p"/gupshup/message/#{incoming_message}")
  #     assert response(conn, 204)

  #     assert_error_sent 404, fn ->
  #       get(conn, ~p"/gupshup/message/#{incoming_message}")
  #     end
  #   end
  # end

  defp create_incoming_message(_) do
    incoming_message = incoming_message_fixture()
    %{incoming_message: incoming_message}
  end
end
