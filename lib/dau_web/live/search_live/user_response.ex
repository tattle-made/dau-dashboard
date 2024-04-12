defmodule DAUWeb.SearchLive.UserResponse do
  alias DAU.UserMessage
  use DAUWeb, :live_view
  use DAUWeb, :html

  def mount(params, session, socket) do
    {:ok, socket}
  end

  def handle_params(unsigned_params, _uri, socket) do
    %{"id" => feed_common_id} = unsigned_params
    user_queries = UserMessage.list_queries(feed_common_id)

    IO.inspect(user_queries)

    socket =
      socket
      |> assign(:queries, [user_queries])

    {:noreply, socket}
  end

  def handle_event("send-response", unsigned_params, socket) do
    query =
      socket.assigns.queries
      |> Enum.filter(fn query -> query.id == unsigned_params["id"] end)
      |> hd

    socket =
      case UserMessage.send_response(query.user_message_outbox) do
        {:ok} ->
          socket
          |> put_flash(:info, "Message sent to BSP")

        {:error, reason} ->
          socket
          |> put_flash(:info, reason)
      end

    {:noreply, socket}
  end
end
