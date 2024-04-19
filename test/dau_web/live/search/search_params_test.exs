defmodule DAUWeb.Search.SearchParamsTest do
  use DAUWeb.ConnCase, async: true
  alias DAUWeb.SearchLive.SearchParams

  @valid_complete_search_param %{
    "page_num" => "1",
    "sort" => "newest",
    "media_type" => "all",
    "from" => "2024-03-01",
    "to" => "2024-04-14",
    "taken_up_by" => "someone"
  }
  @valid_partial_search_param %{
    "page_num" => "1",
    "sort" => "oldest",
    "media_type" => "audio"
  }
  @valid_complete_search_keywords [
    page_num: 1,
    sort: "newest",
    media_type: "all",
    from: "2024-03-01",
    to: "2024-04-14",
    verification_status: "all",
    taken_up_by: "someone"
  ]

  describe "parsing search parameters" do
    test "complete parameters in query string" do
      params = SearchParams.params_to_keyword_list(@valid_complete_search_param)
      assert Keyword.equal?(params, @valid_complete_search_keywords)
    end

    test "parsing partial parameters in query string" do
      params_external = %{
        "sort" => "newest",
        "media_type" => "video"
      }

      params = SearchParams.params_to_keyword_list(params_external)

      expected_params =
        Keyword.new()
        |> Keyword.put(:page_num, 1)
        |> Keyword.put(:sort, "newest")
        |> Keyword.put(:media_type, "video")
        |> Keyword.put(:from, "2024-03-01")
        |> Keyword.put(:to, Date.to_iso8601(Date.utc_today()))
        |> Keyword.put(:verification_status, "all")
        |> Keyword.put(:taken_up_by, nil)

      assert Keyword.equal?(params, expected_params)
    end

    test "convert page_num to integer" do
      params_external = %{
        "page_num" => "1"
      }

      params = SearchParams.params_to_keyword_list(params_external)
      assert Keyword.get(params, :page_num) == 1
    end

    test "excluding illegal parameters in query string" do
      params_external = %{
        "asdfa" => "asdf",
        "afad" => 2,
        "sort" => "oldest"
      }

      params = SearchParams.params_to_keyword_list(params_external)
      assert Keyword.get(params, :afad) == nil
      assert Keyword.get(params, :asdfa) == nil
      assert Keyword.get(params, :sort) == "oldest"
    end
  end

  describe "generate search string" do
    test "query string for complete param" do
      query_string = SearchParams.search_param_string(@valid_complete_search_keywords)

      assert query_string ==
               "page_num=1&sort=newest&media_type=all&from=2024-03-01&to=2024-04-14&verification_status=all&taken_up_by=someone"
    end

    test "query string for incomplete param" do
      query_string = SearchParams.search_param_string(@valid_partial_search_param)
      assert query_string == "media_type=audio&page_num=1&sort=oldest"
    end

    test "search param for next page" do
      query_string = SearchParams.search_param_string_for_next_page(page_num: 2)

      assert query_string == "page_num=3"
    end

    test "search param for previous page" do
      query_string = SearchParams.search_param_string_for_previous_page(page_num: 3)
      assert query_string == "page_num=2"

      query_string = SearchParams.search_param_string_for_previous_page(page_num: 1)
      assert query_string == "page_num=1"
    end

    test "taken up by filter" do
      params_external = %{
        # can also be no one
        "taken_up_by" => "someone"
      }

      params_keyword_list = SearchParams.params_to_keyword_list(params_external)

      assert Keyword.get(params_keyword_list, :taken_up_by) == "someone"

      # IO.inspect(params_keyword_list)
    end
  end
end
