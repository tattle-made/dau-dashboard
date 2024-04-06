defmodule DAUWeb.SearchLive.SearchParams do
  @allowed_filter_keys ["media_type", "page_num", "sort", "verification_status", "from", "to"]
  @default_filter_params [
    page_num: "1",
    sort: "newest",
    media_type: "all",
    from: "2024-03-01",
    to: Date.to_iso8601(Date.utc_today()),
    verification_status: "all"
  ]

  def params_to_keyword_list(params) do
    {:ok, params} =
      Enum.filter(params, fn {key, _value} -> Enum.member?(@allowed_filter_keys, key) end)
      |> Enum.filter(fn {_key, value} -> value || false end)
      |> Enum.map(fn {key, value} -> {String.to_existing_atom(key), value} end)
      |> Keyword.validate(@default_filter_params)

    params |> convert_page_num_to_integer
  end

  defp convert_page_num_to_integer(params_keyword) do
    Keyword.update(params_keyword, :page_num, 1, fn value -> String.to_integer(value) end)
  end

  def update_search_param(search_params, value) do
    case value["name"] do
      "sort-by" ->
        Keyword.put(search_params, :sort, value["value"])

      "date-range" ->
        case value["type"] do
          "start" -> Keyword.put(search_params, :from, value["value"])
          "end" -> Keyword.put(search_params, :to, value["value"])
        end

      "media_type" ->
        Keyword.put(search_params, :media_type, String.to_existing_atom(value["value"]))

      "verification_status" ->
        Keyword.put(
          search_params,
          :verification_status,
          String.to_existing_atom(value["value"])
        )

      _ ->
        search_params
    end
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
end
