defmodule DAUWeb.SearchLive.Index do
  alias DAUWeb.SearchLive.SearchParams
  alias DAU.Feed
  alias DAU.Accounts
  alias DauWeb.SearchLive.Data
  use DAUWeb, :live_view
  use DAUWeb, :html

  def mount(_params, session, socket) do
    # queries = Feed.list_common_feed(1)
    user_token = session["user_token"]
    user = user_token && Accounts.get_user_by_session_token(user_token)

    IO.inspect(user)

    socket =
      socket
      # |> assign(:queries, queries)
      |> assign(:selection, [])
      |> assign(:current_user_id, user.id)
      |> assign(:current_user_name, String.split(user.email, "@") |> hd)
      # |> assign
      |> assign(:page_num, 1)

    {:ok, socket}
  end

  @doc """
    feed : :common, :my_feed
    sort: :newest, :oldest, :repetition_count
  """
  def handle_params(params, _uri, socket) do
    page_num = String.to_integer(params["page_num"] || "1")
    sort = params["sort"] || "newest"
    media_type = params["media_type"] || "all"
    feed_name = params["feed_name"] || ""
    verification_status = params["verification_status"] || ""

    search_params = %SearchParams{
      page_num: page_num,
      feed: feed_name,
      media_type: media_type,
      sort: sort,
      verification_status: verification_status
    }

    queries = Feed.list_common_feed(search_params)

    socket =
      socket
      |> assign(:page_num, page_num)
      |> assign(:search_params, search_params)
      |> assign(:queries, queries)
      |> assign(:selection, [])

    {:noreply, socket}
  end

  def handle_event("change-search", value, socket) do
    search_params = socket.assigns.search_params
    IO.inspect(search_params)

    new_search_params =
      case value["name"] do
        "page-next" ->
          current_page = search_params.page_num || 1
          IO.inspect(current_page)
          Map.put(search_params, :page_num, current_page + 1)

        "page-previous" ->
          current_page = search_params.page_num || 1
          Map.put(search_params, :page_num, current_page - 1)

        "feed" ->
          Map.put(search_params, :feed, String.to_atom(value["value"]))

        "sort-by" ->
          Map.put(search_params, :sort, String.to_atom(value["value"]))

        "date-range" ->
          socket

        "media_type" ->
          # check if value["value"] exists
          Map.put(search_params, :media_type, String.to_atom(value["value"]))

        "verification_status" ->
          Map.put(search_params, :verification_status, String.to_atom(value["value"]))

        _ ->
          socket
      end

    {:noreply,
     socket
     |> assign(:search_params, new_search_params)
     |> push_navigate(
       to:
         "/demo/query?page_num#{new_search_params.page_num}&sort=#{new_search_params.sort}&media_type=#{new_search_params.media_type}&verification_status=#{new_search_params.verification_status}"
     )}

    # {:noreply, assign(socket, :queries, queries)}
  end

  def handle_event("change-search-date", value, socket) do
    search_params = socket.assigns.search_params

    socket =
      case value["name"] do
        "from-date" ->
          {:ok, date} = Date.from_iso8601(value["value"])

          new_search_params =
            put_in(search_params, [:date, :from], date)

          assign(socket, :search_params, new_search_params)

        "to-date" ->
          {:ok, date} = Date.from_iso8601(value["value"])

          new_search_params =
            put_in(search_params, [:date, :to], date)

          assign(socket, :search_params, new_search_params)
      end

    {:noreply, socket}
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
    # selection = socket.assigns.selection
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
    page_num = socket.assigns.page_num
    search_params = socket.assigns.search_params

    Enum.map(selection, fn id ->
      Feed.get_feed_item_by_id(id)
      |> Feed.take_up(user)
    end)

    queries = Feed.list_common_feed(search_params)
    {:noreply, assign(socket, :queries, queries) |> assign(:selection, [])}
  end

  defp humanize_date(date) do
    Timex.to_datetime(date, "Asia/Calcutta")
    |> Calendar.strftime("%a %d-%m-%Y %I:%M %P")
  end

  def search_string(search_params, opts) do
    # :paginate action is sent by the pagination buttons. Can be :increment or :decrement
    paginate_action = Keyword.get(opts, :paginate_action, :none)

    page_num =
      case paginate_action do
        :increment -> Map.put(search_params, :page_num, search_params.page_num + 1)
        :decrement -> Map.put(search_params, :page_num, search_params.page_num - 1)
      end

    ~p"/demo/query?page_num=#{page_num}&sort=#{search_params.sort}&media_type=#{search_params.media_type}&verification_status=#{search_params.verification_status}"
  end
end
