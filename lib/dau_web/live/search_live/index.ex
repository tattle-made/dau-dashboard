defmodule DAUWeb.SearchLive.Index do
  alias DAU.Feed
  alias DAU.Accounts
  alias DauWeb.SearchLive.Data
  use DAUWeb, :live_view
  use DAUWeb, :html

  def mount(params, session, socket) do
    queries = Feed.list_common_feed(1)

    # IO.inspect(queries |> hd)

    user_token = session["user_token"]
    user = user_token && Accounts.get_user_by_session_token(user_token)
    # IO.inspect(user)

    socket =
      socket
      |> assign(:queries, queries)
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
  def handle_params(params, uri, socket) do
    search_params = %{
      feed: :common,
      media_type: [:video, :audio],
      date: %{from: ~D[2024-03-01], to: ~D[2024-03-10]},
      sort: :oldest
    }

    page_num = String.to_integer(params["page_num"] || 1)
    IO.inspect("====")
    IO.inspect(page_num)
    IO.inspect("====")
    queries = Feed.list_common_feed(1)

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

    socket =
      case value["name"] do
        "feed" ->
          new_search_params =
            Map.put(search_params, :feed, String.to_existing_atom(value["value"]))

          assign(socket, :search_params, new_search_params)

        "sort-by" ->
          new_search_params =
            Map.put(search_params, :sort, String.to_existing_atom(value["value"]))

          assign(socket, :search_params, new_search_params)

        "date-range" ->
          socket

        "media_type" ->
          # check if value["value"] exists

          media =
            case value["value"] do
              nil -> search_params.media_type -- [String.to_existing_atom(value["id"])]
              _ -> search_params.media_type ++ [String.to_existing_atom(value["id"])]
            end

          new_search_params = Map.put(search_params, :media_type, media)

          assign(socket, :search_params, new_search_params)

        _ ->
          # IO.inspect("unsupported change")
          # IO.inspect(value)
          socket
      end

    # fetch data from db and add to socket
    IO.inspect(socket.assigns.search_params)
    queries = Feed.list_common_feed(socket.assigns.search_params)

    {:noreply, assign(socket, :queries, queries)}
  end

  def handle_event("change-search-date", value, socket) do
    search_params = socket.assigns.search_params
    # IO.inspect(value)
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
    IO.inspect("selected one key")
    IO.inspect(value)

    selection_type =
      case {} |> Tuple.insert_at(0, value["id"]) |> Tuple.insert_at(1, value["value"]) do
        {_id, nil} -> :subtract
        {_id, _value} -> :add
      end

    IO.inspect(selection_type)

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

    IO.inspect(socket.assigns.selection)

    {:noreply, socket}
  end

  def handle_event("select-all", value, socket) do
    {:noreply, socket}
  end

  def handle_event("mark-as-spam", value, socket) do
    selection = socket.assigns.selection
    IO.inspect(selection)
    {:noreply, socket}
  end

  def handle_event("delete", value, socket) do
    {:noreply, socket}
  end

  def handle_event("assign-to", value, socket) do
    queries = Data.assign_to(socket.assigns.queries, hd(socket.assigns.selection), value["id"])
    {:noreply, assign(socket, :queries, queries) |> assign(:selection, [])}
  end

  def handle_event("take-up", value, socket) do
    IO.inspect(socket.assigns.selection)
    selection = socket.assigns.selection
    user = socket.assigns.current_user_name
    page_num = socket.assigns.page_num

    result =
      Enum.map(selection, fn id ->
        Feed.get_feed_item_by_id(id)
        |> Feed.take_up(user)
      end)

    IO.inspect(result)

    queries = Feed.list_common_feed(page_num)
    # queries = Data.assign_to(socket.assigns.queries, hd(socket.assigns.selection), "areeba")
    {:noreply, assign(socket, :queries, queries) |> assign(:selection, [])}
    # {:noreply, socket}
  end

  def handle_event("page-next", _value, socket) do
    page_num = socket.assigns.page_num
    new_page_num = page_num + 1
    queries = Feed.list_common_feed(new_page_num)

    socket =
      socket
      |> assign(:page_num, new_page_num)
      |> assign(:queries, queries)

    {:noreply, socket}
  end

  def handle_event("page-previous", _value, socket) do
    page_num = socket.assigns.page_num
    new_page_num = if page_num > 1, do: page_num - 1, else: 1

    queries = Feed.list_common_feed(page_num)

    socket =
      socket
      |> assign(:page_num, new_page_num)
      |> assign(:queries, queries)

    {:noreply, socket}
  end

  def handle_params(params, uri, socket) do
    IO.inspect(params)
    {:noreply, socket}
  end
end
