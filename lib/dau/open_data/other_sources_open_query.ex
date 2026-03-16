defmodule DAU.OpenData.OtherSourcesOpenQuery do
  import Ecto.Query, warn: false
  alias DAU.OpenData.PartnerEscalation
  alias DAU.OpenData.AssessmentReport
  alias DAU.OpenData.AssessmentReportTag
  alias DAU.OpenData.PartnerEscalationTag
  alias DAU.OpenData.Tag

  alias DAU.Repo

  @page_size 25

  def list_combined_data(search_params) do
    order = %{
      "newest" => [desc: :date],
      "oldest" => [asc: :date]
    }

    tag_filter = present_filter(Keyword.get(search_params, :tag))

    query =
      make_base_query(tag_filter)
      # Wrap the union so we can safely order/limit/offset on combined fields.
      |> subquery()
      |> maybe_filter_from_date(Keyword.get(search_params, :from))
      |> maybe_filter_to_date(Keyword.get(search_params, :to))

    count = Repo.aggregate(query, :count, :uuid)

    results =
      query
      |> order_by(^Map.get(order, Keyword.get(search_params, :sort), desc: :date))
      |> limit(^@page_size)
      |> offset(^(@page_size * (Keyword.get(search_params, :page_num, 1) - 1)))
      |> Repo.all()
      |> bulk_add_s3_media_url()

    {count, results}
  end

  defp make_base_query(tag_filter) do
    # Build partner rows with tags aggregated into a JSON array per row.
    query_partners =
      PartnerEscalation
      # Left join keeps rows even when no tags exist.
      |> join(:left, [row], t in assoc(row, :tags))
      |> where([row], row.media_urls != [] and not is_nil(row.media_urls))
      |> where(
        [row],
        fragment(
          "EXISTS (SELECT 1 FROM unnest(?) AS u(url) WHERE u.url ~* ?)",
          row.media_urls,
          "^(https?://)"
        )
      )
      |> maybe_filter_tags_for_partner(tag_filter)
      # Group by row.id so the tag join doesn't multiply rows.
      |> group_by([row], row.id)
      |> select([row, t], %{
        type: "partner",
        date: row.date,
        preview_url: nil,
        assessment_report_link: nil,
        count: row.count,
        tools_used: row.tools_used,
        observations: row.observations,
        uuid: row.uuid,
        # Aggregate tag slug+name into a JSONB array; empty array when no tags.
        tags:
          fragment(
            "coalesce(jsonb_agg(DISTINCT jsonb_build_object('slug', ?, 'name', ?)) FILTER (WHERE ? IS NOT NULL), '[]'::jsonb)",
            t.slug,
            t.name,
            t.slug
          )
      })

    # Build assessment report rows with tags aggregated into a JSON array per row.
    query_reports =
      AssessmentReport
      # Left join keeps rows even when no tags exist.
      |> join(:left, [row], t in assoc(row, :tags))
      |> where([row], row.media_urls != [] and not is_nil(row.media_urls))
      |> where(
        [row],
        fragment(
          "EXISTS (SELECT 1 FROM unnest(?) AS u(url) WHERE u.url ~* ?)",
          row.media_urls,
          "^(https?://)"
        )
      )
      |> maybe_filter_tags_for_report(tag_filter)
      # Group by row.id so the tag join doesn't multiply rows.
      |> group_by([row], row.id)
      |> select([row, t], %{
        type: "assessment_report",
        date: row.date,
        preview_url: nil,
        assessment_report_link: row.assessment_report_link,
        count: nil,
        tools_used: row.tools_used,
        observations: row.observations,
        uuid: row.uuid,
        # Aggregate tag slug+name into a JSONB array; empty array when no tags.
        tags:
          fragment(
            "coalesce(jsonb_agg(DISTINCT jsonb_build_object('slug', ?, 'name', ?)) FILTER (WHERE ? IS NOT NULL), '[]'::jsonb)",
            t.slug,
            t.name,
            t.slug
          )
      })

    union_all(query_partners, ^query_reports)
  end

  def page_size, do: @page_size

  defp maybe_filter_from_date(query, nil), do: query

  defp maybe_filter_from_date(query, date_string) do
    case Date.from_iso8601(date_string) do
      {:ok, date} ->
        where(query, [c], c.date >= ^date)

      _ ->
        query
    end
  end

  defp maybe_filter_to_date(query, nil), do: query

  defp maybe_filter_to_date(query, date_string) do
    case Date.from_iso8601(date_string) do
      {:ok, date} ->
        where(query, [c], c.date <= ^date)

      _ ->
        query
    end
  end

  defp maybe_filter_tags_for_partner(query, nil), do: query

  defp maybe_filter_tags_for_partner(query, tag_slug) do
    # Filter rows by tag without shrinking the aggregated tag list.

    #explaination in below function
    where(query, [row, _t],
      fragment(
        "EXISTS (SELECT 1 FROM partner_escalation_tags pet JOIN tags t ON t.id = pet.tag_id WHERE pet.partner_escalation_id = ? AND t.slug = ?)",
        row.id,
        ^tag_slug
      )
    )
  end

  defp maybe_filter_tags_for_report(query, nil), do: query

  defp maybe_filter_tags_for_report(query, tag_slug) do
    # Filter rows by tag without shrinking the aggregated tag list.

# The outer query has row (report) and t (joined tags for aggregation).
# The WHERE EXISTS (...) is evaluated for each row.
# Inside the EXISTS, we join the report‑tag join table to tags, and check:
# assessment_report_id = row.id
# tag.slug = desired slug
# If a match exists → keep that row in the outer query.
# If not → that row is filtered out.

# The issue with the normal filtering is that this is happening before we are aggregating the tags
# in the select. So, if a row had 3 tags t1, t2, t3. In normal filtering for t1, the
# rows with t2, t3 will get discarded from the join. This would result in rows still being
# properly filtered, but in the tags field of rows, we would have not gotten all the tags for the row (
# because they were deleted from the join table earlier). therefor this approach.

    where(query, [row, _t],
      fragment(
        "EXISTS (SELECT 1 FROM assessment_report_tags art JOIN tags t ON t.id = art.tag_id WHERE art.assessment_report_id = ? AND t.slug = ?)",
        row.id,
        ^tag_slug
      )
    )
  end

  defp present_filter(value) when value in [nil, "", "all"], do: nil
  defp present_filter(value), do: value

  defp bulk_add_s3_media_url(rows) do
    base_preview_url = Application.fetch_env!(:dau, :preview_other_sources_dataset_base_s3_url)

    Enum.map(rows, fn row ->
      Map.put(row, :preview_url, base_preview_url <> "thumbnail_" <> row.uuid <> ".png")
    end)
  end
end
