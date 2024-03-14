defmodule DAU.Feed do
  import Ecto.Query, warn: false
  alias DAU.UserMessage.MessageDelivery
  alias DAU.Repo

  alias DAU.Feed.Common

  def add_to_common_feed(attrs \\ %{}) do
    %Common{}
    |> Common.changeset(attrs)
    |> Repo.insert()
  end

  def list_common_feed(page_num \\ 1) do
    # search_params = %{
    #   taken_by: "areeba",
    #   sort: :oldest
    # }

    order = [desc: :inserted_at]

    Common
    |> offset(10 * (^page_num - 1))
    |> limit(10)
    |> order_by(^order)
    |> Repo.all()
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
    %{
      date: %{to: ~D[2024-03-10], from: ~D[2024-03-01]},
      sort: :oldest,
      media_type: [:video, :audio],
      feed: :common
    }
  """
  def list_common_feed(%{date: date, media_type: media_type, sort: sort} = search_params) do
    query =
      Common
      |> limit(10)

    query =
      if Enum.member?(media_type, :video),
        do: query |> where([c], c.media_type == :video),
        else: query

    query =
      if Enum.member?(media_type, :audio),
        do: query |> where([c], c.media_type == :audio),
        else: query

    query =
      case media_type do
        [:audio] ->
          query |> where([c], c.media_type == :audio)

        [:video] ->
          query |> where([c], c.media_type == :video)

        [:audio, :video] ->
          query |> where([c], c.media_type == :video) |> where([c], c.media_type == :audio)

        [] ->
          query |> where([c], c.media_type != :video) |> where([c], c.media_type != :audio)
      end

    # query =
    #   case(sort) do
    #     :oldest -> query |> order_by(desc: :inserted_at)
    #     :newest -> query |> order_by(asc: :inserted_at)
    #   end
    query =
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

  def add_verification_note() do
  end

  def add_tag(%Common{} = common, tag) do
  end

  def add_assessment_skeleton() do
  end

  def add_user_response(id, message) do
    # common
    # |> Common.user_response_changeset(%{user_response: message})
    # |> Repo.update()
  end

  def filter(params) do
    # sort by chronology
    # date range
    # language
    #
  end

  def take_up(%Common{} = common, user_name) do
    common
    |> Common.take_up_changeset(%{taken_by: user_name})
    |> Repo.update()
  end

  defp bulk_add_s3_media_url(common) do
    common
    |> Enum.map(fn query ->
      {_, map} =
        Map.get_and_update(query, :media_urls, &{&1, Enum.map(&1, fn key -> "/temp/#{key}" end)})

      {_, map} =
        map
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
end
