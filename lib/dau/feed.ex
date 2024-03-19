defmodule DAU.Feed do
  import Ecto.Query, warn: false
  alias DAU.Feed.Resource
  alias DAU.Feed.Common.FactcheckArticle
  alias DAUWeb.SearchLive.SearchParams
  alias DAU.UserMessage.MessageDelivery
  alias DAU.Repo

  alias DAU.Feed.Common

  def add_to_common_feed(attrs \\ %{}) do
    %Common{}
    |> Common.changeset(attrs)
    |> Repo.insert()
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
  def list_common_feed(%SearchParams{} = search_params) do
    order = %{
      "newest" => [desc: :inserted_at],
      "oldest" => [asc: :inserted_at]
    }

    query =
      Common
      |> limit(25)
      |> offset(25 * (^search_params.page_num - 1))

    query =
      case search_params.media_type do
        "video" -> query |> where([c], c.media_type == :video)
        "audio" -> query |> where([c], c.media_type == :audio)
        "all" -> query
        nil -> query
        _ -> query
      end

    query =
      case search_params.verification_status do
        "deepfake" -> query |> where([c], c.verification_status == :deepfake)
        "manipulated" -> query |> where([c], c.verification_status == :manipulated)
        "not_manipulated" -> query |> where([c], c.verification_status == :not_manipulated)
        "inconclusive" -> query |> where([c], c.verification_status == :inconclusive)
        nil -> query
        _ -> query
      end

    query =
      query
      |> order_by(^order[search_params.sort])

    query = query |> Repo.all() |> bulk_add_s3_media_url

    query
  end

  def get_feed_item_by_id(id) do
    {_, query} =
      Repo.get!(Common, id)
      |> Map.get_and_update(:media_urls, fn urls ->
        new_value =
          Enum.map(urls, fn url ->
            {:ok, url} = AWSS3.presigned_url("staging.dau.tattle.co.in", url)
            url
          end)

        {urls, new_value}
      end)

    query
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

      {_, map} =
        query
        |> Map.get_and_update(
          :media_urls,
          &{&1,
           Enum.map(&1, fn key ->
             {:ok, url} = AWSS3.presigned_url("staging.dau.tattle.co.in", key)
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
  def send_assessment_report_to_user(id, message) do
    {:ok, common} =
      Repo.get!(Common, id)
      |> Common.user_response_changeset(%{user_response: message})
      |> Repo.update()

    MessageDelivery.send_message_to_bsp(common.sender_number, message)
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
end
