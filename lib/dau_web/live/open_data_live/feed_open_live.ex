defmodule DAUWeb.OpenDataLive.FeedOpenLive do
  import DAUWeb.OpenDataLive.FeedOpenSearchParams
  import DAUWeb.Components.OpenDataComponents
  alias DAUWeb.OpenDataLive.FeedOpenSearchParams, as: SearchParams
  alias DAU.OpenData
  alias DAU.OpenData.FeedOpenQuery
  use DAUWeb, :live_view
  use DAUWeb, :html

  def mount(_params, session, socket) do
    socket =
      socket
      |> assign(:page_num, 1)
      |> assign(:tag_categories, OpenData.list_tag_categories_with_tags())
      |> assign(:available_tags_for_category, [])

    {:ok, socket}
  end

  @doc """
    feed : :common, :my_feed
    sort: :newest, :oldest, :repetition_count
  """
  def handle_params(params, _uri, socket) do
    search_params = SearchParams.params_to_keyword_list(params)
    tag_categories = OpenData.list_tag_categories_with_tags()

    available_tags_for_category =
      tags_for_category_slug(tag_categories, Keyword.get(search_params, :tag_category))

    {count, results} = FeedOpenQuery.list_common_feed_open(search_params)
    IO.inspect(results)
    page_size = FeedOpenQuery.page_size()
    page_num = Keyword.get(search_params, :page_num)
    total_pages = max(div(count + page_size - 1, page_size), 1)
    has_next_page = page_num < total_pages

    socket =
      socket
      |> assign(:page_num, page_num)
      |> assign(:has_next_page, has_next_page)
      |> assign(:total_pages, total_pages)
      |> assign(:query_count, count)
      |> assign(:search_params, search_params)
      |> assign(:queries, results)
      |> assign(:tag_categories, tag_categories)
      |> assign(:available_tags_for_category, available_tags_for_category)

    {:noreply, socket}
  end

  def handle_event("change-search", value, socket) do
    search_params = socket.assigns.search_params

    new_search_params = SearchParams.update_search_param(search_params, value)

    {:noreply,
     socket
     |> assign(:search_params, new_search_params)
     |> push_navigate(to: "/datasets/preview/whatsapp-tipline-dataset?#{SearchParams.search_param_string(new_search_params)}")}
  end

  defp humanize_date(date) do
    Timex.to_datetime(date, "Asia/Calcutta")
    |> Calendar.strftime("%a %d-%m-%Y")
  end

  def humanize_count(hash_meta) do
    case hash_meta do
      nil -> 1
      _ -> hash_meta.count
    end
  end

  def report_tools(common) do
    common
    |> first_assessment_report()
    |> case do
      nil -> []
      report -> List.wrap(report.tools_used)
    end
  end

  def report_observations(common) do
    common
    |> first_assessment_report()
    |> case do
      nil -> []
      report -> List.wrap(report.observations)
    end
  end

  def report_link(common) do
    case first_assessment_report(common) do
      nil -> nil
      report -> report.assessment_report_link
    end
  end

  defp first_assessment_report(common) do
    common
    |> Map.get(:open_data_assessment_reports, [])
    |> case do
      %Ecto.Association.NotLoaded{} -> []
      reports -> reports
    end
    |> List.wrap()
    |> List.first()
  end

  defp tags_for_category_slug(tag_categories, category_slug) do
    case Enum.find(tag_categories, fn category -> category.slug == category_slug end) do
      nil -> []
      category -> List.wrap(category.tags)
    end
  end

  defp pagination_items(current_page, total_pages) do
    cond do
      total_pages <= 7 ->
        Enum.to_list(1..total_pages)

      current_page <= 3 ->
        [1, 2, 3, 4, :gap, total_pages]

      current_page >= total_pages - 2 ->
        [1, :gap, total_pages - 3, total_pages - 2, total_pages - 1, total_pages]

      true ->
        [1, :gap, current_page - 1, current_page, current_page + 1, :gap, total_pages]
    end
  end
end
