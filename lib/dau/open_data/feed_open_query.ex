defmodule DAU.OpenData.FeedOpenQuery do
  import Ecto.Query, warn: false
  alias DAU.Feed.Common
  alias DAU.Repo

  @page_size 25
  @excluded_common_ids [3912,3889,3601,691,681,680,3899,3898,3724,3732,3656,3638,2104,2097,1661,1594,1586,1570,1564,1490,1360,1361,1349,1348,1102,1035,1034,1033,972,958,719,722,673,671,708,695,639,628,632,629,606,602,598,633,611,605,525,526,519,532,440,298,284,283,278,4500,4501,3848,3847,3958,4569,4570,4571,4468,4378,1299,354,349,2090,4265,4160,4587,4375,4139,3744,857,4365,4070
  ]

  def list_common_feed(search_params) do
    order = %{
      "newest" => [desc: :inserted_at],
      "oldest" => [asc: :inserted_at]
    }

    query =
      Common
      |> maybe_filter_media_type(Keyword.get(search_params, :media_type))
      |> maybe_filter_verification_status(Keyword.get(search_params, :verification_status))
      |> maybe_filter_from_date(Keyword.get(search_params, :from))
      |> maybe_filter_to_date(Keyword.get(search_params, :to))
      # |> maybe_exclude_ids(@excluded_common_ids)
      |> maybe_filter_tags(
        Keyword.get(search_params, :tag_category),
        Keyword.get(search_params, :tag)
      )

    count = Repo.aggregate(query, :count, :id)

    results =
      query
      |> order_by(^Map.get(order, Keyword.get(search_params, :sort), desc: :inserted_at))
      |> limit(^@page_size)
      |> offset(^(@page_size * (Keyword.get(search_params, :page_num, 1) - 1)))
      |> Repo.all()
      |> Repo.preload([:query, :hash_meta, :tag_joins, :open_data_assessment_reports])
      |> bulk_add_s3_media_url()

    {count, results}
  end

  defp maybe_filter_media_type(query, "video"), do: where(query, [c], c.media_type == :video)
  defp maybe_filter_media_type(query, "audio"), do: where(query, [c], c.media_type == :audio)
  defp maybe_filter_media_type(query, _), do: query

  defp maybe_filter_verification_status(query, "deepfake"),
    do: where(query, [c], c.verification_status == :deepfake)

  defp maybe_filter_verification_status(query, "manipulated"),
    do: where(query, [c], c.verification_status == :manipulated)

  defp maybe_filter_verification_status(query, "not_manipulated"),
    do: where(query, [c], c.verification_status == :not_manipulated)

  defp maybe_filter_verification_status(query, "ai_generated"),
    do: where(query, [c], c.verification_status == :ai_generated)

  defp maybe_filter_verification_status(query, "not_ai_generated"),
    do: where(query, [c], c.verification_status == :not_ai_generated)

  defp maybe_filter_verification_status(query, "inconclusive"),
    do: where(query, [c], c.verification_status == :inconclusive)

  defp maybe_filter_verification_status(query, "cheapfake"),
    do: where(query, [c], c.verification_status == :cheapfake)

  defp maybe_filter_verification_status(query, "out_of_scope"),
    do: where(query, [c], c.verification_status == :out_of_scope)

  defp maybe_filter_verification_status(query, "unsupported_language"),
    do: where(query, [c], c.verification_status == :unsupported_language)

  defp maybe_filter_verification_status(query, "spam"),
    do: where(query, [c], c.verification_status == :spam)

  defp maybe_filter_verification_status(query, _), do: query

  defp maybe_filter_from_date(query, nil), do: query

  defp maybe_filter_from_date(query, date_string) do
    case Date.from_iso8601(date_string) do
      {:ok, date} ->
        from_date = DateTime.new!(date, ~T[00:00:00.000], "Asia/Calcutta")
        where(query, [c], c.inserted_at >= ^from_date)

      _ ->
        query
    end
  end

  defp maybe_filter_to_date(query, nil), do: query

  defp maybe_filter_to_date(query, date_string) do
    case Date.from_iso8601(date_string) do
      {:ok, date} ->
        to_date = DateTime.new!(date, ~T[23:59:59.000], "Asia/Calcutta")
        where(query, [c], c.inserted_at <= ^to_date)

      _ ->
        query
    end
  end

  defp maybe_exclude_ids(query, ids) when is_list(ids) and ids != [] do
    where(query, [c], c.id not in ^ids)
  end

  defp maybe_exclude_ids(query, _), do: query

  defp maybe_filter_tags(query, tag_category, tag) do
    category_filter = present_filter(tag_category)
    tag_filter = present_filter(tag)

    case {category_filter, tag_filter} do
      {nil, nil} ->
        query

      {category_slug, nil} ->
        query
        |> join(:inner, [c], t in assoc(c, :tag_joins), as: :tag)
        |> join(:inner, [tag: t], tc in assoc(t, :tags_category), as: :tags_category)
        |> where([tags_category: tc], tc.slug == ^category_slug)
        |> distinct([c], c.id)

      {nil, tag_slug} ->
        query
        |> join(:inner, [c], t in assoc(c, :tag_joins), as: :tag)
        |> where([tag: t], t.slug == ^tag_slug)
        |> distinct([c], c.id)

      {category_slug, tag_slug} ->
        query
        |> join(:inner, [c], t in assoc(c, :tag_joins), as: :tag)
        |> join(:inner, [tag: t], tc in assoc(t, :tags_category), as: :tags_category)
        |> where([tag: t], t.slug == ^tag_slug)
        |> where([tags_category: tc], tc.slug == ^category_slug)
        |> distinct([c], c.id)
    end
  end

  defp present_filter(value) when value in [nil, "", "all"], do: nil
  defp present_filter(value), do: value

  defp bulk_add_s3_media_url(common_rows) do
    Enum.map(common_rows, fn query ->
      media_type = query.media_type

      {_, map} =
        Map.get_and_update(
          query,
          :media_urls,
          &{&1,
           List.wrap(&1)
           |> Enum.map(fn key ->
             if media_type == :video || media_type == :audio do
               case AWSS3.client().presigned_url("staging.dau.tattle.co.in", key) do
                 {:ok, url} -> url
                 _ -> key
               end
             else
               key
             end
           end)}
        )

      map
    end)
  end
end
