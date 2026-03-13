defmodule DAUWeb.OpenDataLive.OtherSourcesOpenLive do
  import DAUWeb.OpenDataLive.OtherSourcesOpenSearchParams
  alias DAUWeb.OpenDataLive.OtherSourcesOpenSearchParams, as: SearchParams
  alias DAU.OpenData.OtherSourcesOpenQuery
  alias DAU.OpenData
  import DAUWeb.Components.OpenDataComponents
  use DAUWeb, :live_view
  use DAUWeb, :html

  @impl Phoenix.LiveView
  def mount(params, session, socket) do
    socket =
      socket
      |> assign(:page_num, 1)
      |> assign(:tags, OpenData.list_languages_tags())

    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def handle_params(params, _uri, socket) do
    search_params = SearchParams.params_to_keyword_list(params)
    {count, results} = OtherSourcesOpenQuery.list_combined_data(search_params)

    page_num = Keyword.get(search_params, :page_num)
    has_next_page = page_num * OtherSourcesOpenQuery.page_size() < count
    tags = OpenData.list_languages_tags()

    socket =
      socket
      |> assign(:page_num, page_num)
      |> assign(:has_next_page, has_next_page)
      |> assign(:query_count, count)
      |> assign(:search_params, search_params)
      |> assign(:queries, results)
      |> assign(:tags, tags)

    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("change-search", value, socket) do
    search_params = socket.assigns.search_params

    new_search_params = SearchParams.update_search_param(search_params, value)

    {:noreply,
     socket
     |> assign(:search_params, new_search_params)
     |> push_navigate(
       to: "/other-sources-open?#{SearchParams.search_param_string(new_search_params)}"
     )}
  end

  defp humanize_date(date) do
    Timex.to_datetime(date, "Asia/Calcutta")
    |> Calendar.strftime("%a %d-%m-%Y")
  end

  def humanize_count(count) do
    case count do
      nil -> 1
      _ -> count
    end
  end

  # def report_tools(common) do
  #   common
  #   |> first_assessment_report()
  #   |> case do
  #     nil -> []
  #     report -> List.wrap(report.tools_used)
  #   end
  # end

  # def report_observations(common) do
  #   common
  #   |> first_assessment_report()
  #   |> case do
  #     nil -> []
  #     report -> List.wrap(report.observations)
  #   end
  # end

end
