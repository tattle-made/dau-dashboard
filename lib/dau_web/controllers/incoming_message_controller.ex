defmodule DAUWeb.IncomingMessageController do
  use DAUWeb, :controller

  alias DAU.UserMessage
  alias DAU.UserMessage.IncomingMessage

  action_fallback DAUWeb.FallbackController

  def index(conn, _params) do
    incoming_messages = UserMessage.list_incoming_messages()
    render(conn, :index, incoming_messages: incoming_messages)
  end

  def create(conn, %{"incoming_message" => incoming_message_params}) do
    with {:ok, %IncomingMessage{} = incoming_message} <- UserMessage.create_incoming_message(incoming_message_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/incoming_messages/#{incoming_message}")
      |> render(:show, incoming_message: incoming_message)
    end
  end

  def show(conn, %{"id" => id}) do
    incoming_message = UserMessage.get_incoming_message!(id)
    render(conn, :show, incoming_message: incoming_message)
  end

  def update(conn, %{"id" => id, "incoming_message" => incoming_message_params}) do
    incoming_message = UserMessage.get_incoming_message!(id)

    with {:ok, %IncomingMessage{} = incoming_message} <- UserMessage.update_incoming_message(incoming_message, incoming_message_params) do
      render(conn, :show, incoming_message: incoming_message)
    end
  end

  def delete(conn, %{"id" => id}) do
    incoming_message = UserMessage.get_incoming_message!(id)

    with {:ok, %IncomingMessage{}} <- UserMessage.delete_incoming_message(incoming_message) do
      send_resp(conn, :no_content, "")
    end
  end
end
