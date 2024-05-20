defmodule DAUWeb.SearchLive.Index do
  import DAUWeb.SearchLive.SearchParams
  alias DAU.UserMessage.Query
  alias DAUWeb.SearchLive.SearchParams
  alias DAU.Feed
  alias DAU.Accounts
  alias DauWeb.SearchLive.Data
  use DAUWeb, :live_view
  use DAUWeb, :html

  def mount(_params, session, socket) do
    user_token = session["user_token"]
    user = user_token && Accounts.get_user_by_session_token(user_token)

    socket =
      socket
      |> assign(:selection, [])
      |> assign(:current_user_id, user.id)
      |> assign(:current_user_name, String.split(user.email, "@") |> hd)
      |> assign(:page_num, 1)

    {:ok, socket}
  end

  @doc """
    feed : :common, :my_feed
    sort: :newest, :oldest, :repetition_count
  """
  def handle_params(params, _uri, socket) do
    search_params = SearchParams.params_to_keyword_list(params)

    {count, results} = Feed.list_common_feed(search_params)

    socket =
      socket
      |> assign(:page_num, Keyword.get(search_params, :page_num))
      |> assign(:query_count, count)
      |> assign(:search_params, search_params)
      |> assign(:queries, results)
      |> assign(:selection, [])

    {:noreply, socket}
  end

  def handle_event("change-search", value, socket) do
    search_params = socket.assigns.search_params

    new_search_params = SearchParams.update_search_param(search_params, value)

    {:noreply,
     socket
     |> assign(:search_params, new_search_params)
     |> push_navigate(to: "/demo/query?#{SearchParams.search_param_string(new_search_params)}")}
  end

  def handle_event("select-one", value, socket) do
    selection_type =
      case {} |> Tuple.insert_at(0, value["id"]) |> Tuple.insert_at(1, value["value"]) do
        {_id, nil} -> :subtract
        {_id, _value} -> :add
      end

    socket =
      case selection_type == :add && !Enum.member?(socket.assigns.selection, value["value"]) do
        true -> assign(socket, :selection, [value["value"] | socket.assigns.selection])
        false -> socket
      end

    socket =
      case selection_type == :subtract && Enum.member?(socket.assigns.selection, value["id"]) do
        true -> assign(socket, :selection, List.delete(socket.assigns.selection, value["id"]))
        false -> socket
      end

    {:noreply, socket}
  end

  def handle_event("select-all", _value, socket) do
    {:noreply, socket}
  end

  def handle_event("mark-as-spam", _value, socket) do
    selection = socket.assigns.selection
    search_params = socket.assigns.search_params

    Enum.map(selection, fn id ->
      with query <- Feed.get_feed_item_by_id(id),
           {:ok, _} <- Feed.add_user_response_label(query, %{verification_status: :spam}) do
        IO.puts("#{id} marked as spam")
      else
        _ -> IO.puts("error marking spam #{id}")
      end
    end)

    {count, results} = Feed.list_common_feed(search_params)

    socket =
      socket
      |> assign(:queries, results)
      |> assign(:query_count, count)
      |> assign(:selection, [])

    {:noreply, socket}
  end

  def handle_event("delete", _value, socket) do
    {:noreply, socket}
  end

  def handle_event("assign-to", value, socket) do
    queries = Data.assign_to(socket.assigns.queries, hd(socket.assigns.selection), value["id"])
    {:noreply, assign(socket, :queries, queries) |> assign(:selection, [])}
  end

  def handle_event("take-up", _value, socket) do
    selection = socket.assigns.selection
    user = socket.assigns.current_user_name
    _page_num = socket.assigns.page_num
    search_params = socket.assigns.search_params

    Enum.map(selection, fn id ->
      Feed.get_feed_item_by_id(id)
      |> Feed.take_up(user)
    end)

    {_count, results} = Feed.list_common_feed(search_params)
    {:noreply, assign(socket, :queries, results) |> assign(:selection, [])}
  end

  defp humanize_date(date) do
    Timex.to_datetime(date, "Asia/Calcutta")
    |> Calendar.strftime("%a %d-%m-%Y %I:%M %P")
  end

  def humanize_count(hash_meta) do
    case hash_meta do
      nil -> 1
      _ -> hash_meta.count
    end
  end
end
