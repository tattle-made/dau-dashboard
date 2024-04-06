defmodule DAUWeb.IncomingMessageControllerTest do
  use DAUWeb.ConnCase

  describe "index" do
    test "lists all incoming_messages" do
    end
  end

  describe "create incoming_message" do
    test "renders incoming_message when data is valid" do
    end

    test "renders errors when data is invalid" do
    end
  end

  describe "update incoming_message" do
    # setup [:create_incoming_message]

    test "renders incoming_message when data is valid" do
    end

    test "renders errors when data is invalid" do
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

  # defp create_incoming_message(_) do
  #   incoming_message = incoming_message_fixture()
  #   %{incoming_message: incoming_message}
  # end
end
