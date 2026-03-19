defmodule DAUWeb.OpenDataLive.FeedOpenSearchParams do
  @allowed_filter_keys [
    "media_type",
    "page_num",
    "sort",
    "verification_status",
    "from",
    "to",
    "tag_category",
    "tag"
  ]

  def params_to_keyword_list(params) do
    default_filter_params = [
      page_num: 1,
      sort: "newest",
      media_type: "all",
      from: "2024-03-01",
      to: Timex.now("Asia/Calcutta") |> DateTime.to_date() |> Date.to_iso8601(),
      verification_status: "all",
      tag_category: "all",
      tag: "all"
    ]

    {:ok, params} =
      params
      |> Enum.filter(fn {key, _value} -> Enum.member?(@allowed_filter_keys, key) end)
      |> Enum.filter(fn {_key, value} -> value || false end)
      |> Enum.map(fn {key, value} -> {String.to_existing_atom(key), value} end)
      |> Keyword.validate(default_filter_params)

    params
    |> convert_page_num_to_integer()
  end

  defp convert_page_num_to_integer(params_keyword) do
    Keyword.update(params_keyword, :page_num, 1, fn value ->
      case value do
        int when is_integer(int) ->
          int

        string when is_binary(string) ->
          case Integer.parse(string) do
            {page_num, _} when page_num > 0 -> page_num
            _ -> 1
          end
      end
    end)
  end

  def update_search_param(search_params, value) do
    search_params = reset_page_num(search_params)

    case value["name"] do
      "sort-by" ->
        Keyword.put(search_params, :sort, value["value"])

      "date-range" ->
        case value["type"] do
          "start" -> Keyword.put(search_params, :from, value["value"])
          "end" -> Keyword.put(search_params, :to, value["value"])
        end

      "media_type" ->
        Keyword.put(search_params, :media_type, value["value"])

      "verification_status" ->
        Keyword.put(search_params, :verification_status, value["value"])

      "tag_category" ->
        search_params
        |> Keyword.put(:tag_category, value["value"])
        |> Keyword.put(:tag, "all")

      "tag" ->
        Keyword.put(search_params, :tag, value["value"])

      _ ->
        search_params
    end
  end

  defp reset_page_num(search_params) do
    Keyword.put(search_params, :page_num, 1)
  end

  def search_param_string(search_params) do
    search_params
    |> Enum.reduce("", fn x, acc -> "#{acc}&#{elem(x, 0)}=#{elem(x, 1)}" end)
    |> String.slice(1..-1)
  end

  def search_param_string_for_next_page(search_params) do
    search_params
    |> Keyword.update(:page_num, 1, fn page_num -> page_num + 1 end)
    |> search_param_string()
  end

  def search_param_string_for_previous_page(search_params) do
    search_params
    |> Keyword.update(:page_num, 1, fn page_num -> if page_num == 1, do: 1, else: page_num - 1 end)
    |> search_param_string()
  end

  def search_param_string_for_page(search_params, page_num) when is_integer(page_num) and page_num > 0 do
    search_params
    |> Keyword.put(:page_num, page_num)
    |> search_param_string()
  end
end
