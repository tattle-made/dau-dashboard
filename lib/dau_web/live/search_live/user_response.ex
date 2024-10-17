defmodule DAUWeb.SearchLive.UserResponse do
  alias DAU.Repo
  alias DAU.Feed.Common
  alias DAU.UserMessage.Analytics
  alias DAU.Accounts
  alias DAU.UserMessage
  alias DAU.UserMessage.Outbox
  alias DAUWeb.SearchLive.Detail
  use DAUWeb, :live_view
  use DAUWeb, :html

  def mount(_params, session, socket) do
    user_token = session["user_token"]
    user = user_token && Accounts.get_user_by_session_token(user_token)

    socket =
      socket
      |> assign(:current_user, user)

    {:ok, socket}
  end

  def handle_params(unsigned_params, _uri, socket) do
    %{"id" => feed_common_id} = unsigned_params
    user_queries = UserMessage.list_queries(feed_common_id)

    # require IEx
    # IEx.pry()

    socket =
      socket
      |> assign(:queries, [user_queries])
      |> assign_async(:events, fn ->
        {:ok, %{events: Analytics.get_all_for_feed_common!(feed_common_id)}}
      end)

    {:noreply, socket}
  end

  def handle_event("send-response", unsigned_params, socket) do

    query =
      socket.assigns.queries
      |> Enum.filter(fn query -> query.id == unsigned_params["id"] end)
      |> hd

    common = Repo.get(Common, query.feed_common_id)

    response_params = DAUWeb.SearchLive.Detail.get_templatized_response_paramters(common)

    socket =
      case UserMessage.send_response(query.user_message_outbox, response_params) do
        {:ok} ->
          socket
          |> put_flash(:info, "Message sent to BSP")

        {:error, reason} ->
          socket
          |> put_flash(:info, reason)
      end

    {:noreply, socket}
  end

  def humanize_date(date) do
    Timex.to_datetime(date, "Asia/Calcutta")
    |> Calendar.strftime("%a %d-%m-%Y %I:%M %P")
  end
end
