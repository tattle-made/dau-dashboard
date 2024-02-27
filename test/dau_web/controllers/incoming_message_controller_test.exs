defmodule DAUWeb.IncomingMessageControllerTest do
  use DAUWeb.ConnCase

  import DAU.UserMessageFixtures

  alias DAU.UserMessage.IncomingMessage

  @create_attrs %{
    app: "DemoApp",
    payload: %{
      id: "some payload_id",
      source: "some source",
      type: "some payload_type",
      payload: %{
        text: "some payload text"
      },
      sender: %{
        phone: "some sender_phone",
        name: "some sender_name"
      }
    }
  }
  @update_attrs %{
    app: "DemoApp",
    payload: %{
      id: "some payload_id",
      source: "some source",
      type: "some payload_type",
      payload: %{
        text: "some payload text"
      },
      sender: %{
        phone: "some sender_phone",
        name: "some sender_name"
      }
    }
  }
  @invalid_attrs %{
    app: "DemoApp",
    payload: %{
      id: nil,
      type: nil,
      payload: %{
        text: nil
      },
      sender: %{
        phone: nil,
        name: nil
      }
    }
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
               "context_gsid" => nil,
               "context_id" => nil,
               "payload_caption" => nil,
               "payload_contenttype" => nil,
               "payload_id" => "some payload_id",
               "payload_text" => "some payload text",
               "payload_type" => "some payload_type",
               "payload_url" => nil,
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
               "context_gsid" => nil,
               "context_id" => nil,
               "payload_caption" => nil,
               "payload_contenttype" => nil,
               "payload_id" => "some payload_id",
               "payload_text" => "some payload text",
               "payload_type" => "some payload_type",
               "payload_url" => nil,
               "sender_name" => "some sender_name",
               "sender_phone" => "some sender_phone",
               "source" => "some source"
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
