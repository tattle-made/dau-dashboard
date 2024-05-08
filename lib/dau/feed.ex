defmodule DAU.Feed do
  import Ecto.Query, warn: false
  alias DAU.Feed.FactcheckArticle
  alias DAU.Feed.AssessmentReport
  alias DAU.Feed.Resource
  alias DAU.Repo

  alias DAU.Feed.Common

  def add_to_common_feed(attrs \\ %{}) do
    %Common{}
    |> Common.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Added for 0.2.0. Common is now linked to queries and does not store all information related to user along with it.
  """
  def add_to_common_feed("0.2.0", attrs) do
    %Common{}
    |> Common.changeset_without_user_information(attrs)
    |> Repo.insert()
  end

  def add_to_common_feed_with_timestamp(attrs \\ %{}) do
    %Common{}
    |> Common.changeset_with_timestamp(attrs)
    |> Repo.insert()
  end

  def add_message_to_query() do
    # if the message is a duplicate of an existing query
    # simply add the query_id to message and update
    # inbox
    # |> Ecto.Changeset.change()
    # |> Ecto.Changeset.put_assoc(:query, common)
    # |> Repo.update

    # if the message is new, create a query with association
    # of message
    # common = %{media_urls: ["app_key/asdfasdf"], media_type: :video, sender_number: "919605048908"}
    #
    # Repo.get(Inbox, 1)
    # |> Repo.preload(:query)
    # |> Ecto.Changeset.cast(%{query: common}, [])
    # |> Ecto.Changeset.cast_assoc(:query, with: &DAU.Feed.Common.changeset/2)
    # |> Repo.update
  end

  def create_query_with_message(_attrs \\ %{}) do
  end

  # def list_common_feed(page_num \\ 1) do
  #   # search_params = %{
  #   #   taken_by: "areeba",
  #   #   sort: :oldest
  #   # }

  #   order = [desc: :inserted_at]

  #   Common
  #   |> offset(25 * (^page_num - 1))
  #   |> limit(25)
  #   |> order_by(^order)
  #   |> Repo.all()
  #   |> Enum.map(fn query ->
  #     # {_, map} =
  #     #   Map.get_and_update(query, :media_urls, &{&1, Enum.map(&1, fn key -> "/temp/#{key}" end)})

  #     {_, map} =
  #       query
  #       |> Map.get_and_update(
  #         :media_urls,
  #         &{&1,
  #          Enum.map(&1, fn key ->
  #            {:ok, url} = AWSS3.presigned_url("staging.dau.tattle.co.in", key)
  #            url
  #          end)}
  #       )

  #     map
  #   end)
  # end

  @doc """
    %{
      date: %{to: ~D[2024-03-10], from: ~D[2024-03-01]},
      sort: :oldest,
      media_type: "video" || "audio" ||  ":all",
      feed: :common
    }
  """
  def list_common_feed(search_params) do
    order = %{
      "newest" => [desc: :inserted_at],
      "oldest" => [asc: :inserted_at]
    }

    query =
      Common
      |> limit(25)
      |> offset(25 * (^Keyword.get(search_params, :page_num) - 1))

    query =
      case Keyword.get(search_params, :media_type) do
        "video" -> query |> where([c], c.media_type == :video)
        "audio" -> query |> where([c], c.media_type == :audio)
        "all" -> query
        nil -> query
        _ -> query
      end

    query =
      case Keyword.get(search_params, :verification_status) do
        "deepfake" -> query |> where([c], c.verification_status == :deepfake)
        "manipulated" -> query |> where([c], c.verification_status == :manipulated)
        "not_manipulated" -> query |> where([c], c.verification_status == :not_manipulated)
        "inconclusive" -> query |> where([c], c.verification_status == :inconclusive)
        "spam" -> query |> where([c], c.verification_status == :spam)
        "all" -> query
        nil -> query
        _ -> query
      end

    query =
      query
      |> order_by(^order[Keyword.get(search_params, :sort)])

    query =
      case Keyword.get(search_params, :from) do
        nil ->
          query

        _ ->
          date_string = Keyword.get(search_params, :from)
          date = Date.from_iso8601!(date_string)
          from_date = DateTime.new!(date, ~T[00:00:00.000], "Asia/Calcutta")

          query
          |> where([c], c.inserted_at >= ^from_date)
      end

    query =
      case Keyword.get(search_params, :to) do
        nil ->
          query

        _ ->
          date_string = Keyword.get(search_params, :to)
          date = Date.from_iso8601!(date_string)
          to_date = DateTime.new!(date, ~T[23:59:59.000], "Asia/Calcutta")

          query
          |> where([c], c.inserted_at <= ^to_date)
      end

    query =
      case Keyword.get(search_params, :taken_up_by) do
        "no_one" -> query |> where([c], is_nil(c.taken_by))
        "someone" -> query |> where([c], not is_nil(c.taken_by))
        _ -> query
      end

    count = query |> Repo.aggregate(:count, :id)
    results = query |> Repo.all() |> Repo.preload(:queries) |> bulk_add_s3_media_url

    {count, results}
  end

  def get_feed_item_by_id(id) do
    query = Repo.get(Common, id) |> Repo.preload(:queries)
    media_type = query.media_type

    {_, map} =
      query
      |> Map.get_and_update(
        :media_urls,
        &{&1,
         Enum.map(&1, fn key ->
           url =
             if media_type == :video || media_type == :audio do
               {:ok, url} = AWSS3.presigned_url("staging.dau.tattle.co.in", key)
               url
             else
               key
             end

           url
         end)}
      )

    map
  end

  def add_secratariat_notes(%Common{} = common, attrs \\ %{}) do
    common
    |> Common.annotation_changeset(attrs)
    |> Repo.update()
  end

  def add_user_response_label(%Common{} = common, attrs \\ %{}) do
    common
    |> Common.user_response_label_changeset(attrs)
    |> Repo.update()
  end

  def take_up(%Common{} = common, user_name) do
    common
    |> Common.take_up_changeset(%{taken_by: user_name})
    |> Repo.update()
  end

  defp bulk_add_s3_media_url(common) do
    common
    |> Enum.map(fn query ->
      # {_, map} =
      #   Map.get_and_update(query, :media_urls, &{&1, Enum.map(&1, fn key -> "/temp/#{key}" end)})
      # IO.inspect(query.media_type)
      media_type = query.media_type

      {_, map} =
        query
        |> Map.get_and_update(
          :media_urls,
          &{&1,
           Enum.map(&1, fn key ->
             url =
               if media_type == :video || media_type == :audio do
                 {:ok, url} = AWSS3.presigned_url("staging.dau.tattle.co.in", key)
                 url
               else
                 key
               end

             url
           end)}
        )

      map
    end)
  end

  @doc """
    Sends a message to the user.

    message is a string and target is the user's phone number
  """
  def add_user_response(id, response) do
    {:ok, _common} =
      Repo.get!(Common, id)
      |> Common.user_response_changeset(%{user_response: response})
      |> Repo.update()
  end

  def add_verification_sop(%Common{} = common, attrs) do
    common
    |> Common.verification_sop_changeset(attrs)
    |> Repo.update()
  end

  def add_resource(query_id, %Resource{} = resource) do
    Repo.get!(Common, query_id)
    |> Common.query_with_resource_changeset(resource)
    |> Repo.update()
  end

  def get_resources(query_id) do
    Repo.get!(Common, query_id).resources
  end

  def add_assessment_report(query_id, %AssessmentReport{} = assessment_report) do
    Repo.get!(Common, query_id)
    |> Common.query_with_assessment_report_changeset(assessment_report)
    |> Repo.update()
  end

  def get_assessment_report(query_id) do
    Repo.get!(Common, query_id).assessment_report
  end

  def add_factcheck_article(query_id, %FactcheckArticle{} = factcheck_article) do
    Repo.get!(Common, query_id)
    |> Common.query_with_factcheck_article(factcheck_article)
    |> Repo.update()
  end

  def set_approval_status(query_id, article_id, approval_status) do
    try do
      common = Repo.get!(Common, query_id)

      articles =
        Enum.map(common.factcheck_articles, fn article ->
          if article.id == article_id do
            %{id: article.id, approved: approval_status}
          else
            %{id: article.id}
          end
        end)

      case(
        Common.query_with_updated_factcheck_article_changeset(common, articles)
        |> Repo.update()
      ) do
        {:ok, common} -> {:ok, common}
        {:error, _} -> raise "Unable to update in database"
      end
    rescue
      _err -> {:error, "Unable to approve article"}
    end
  end

  def get_factcheck_articles(query_id) do
    Repo.get!(Common, query_id).factcheck_articles
  end

  def get_queries(feed_common_id) do
    Repo.get!(Common, feed_common_id) |> Repo.preload(queries: [:messages])
  end
end
