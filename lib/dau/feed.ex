defmodule DAU.Feed do
  import Ecto.Query, warn: false
  alias DAU.Repo

  alias DAU.Feed.Common

  def add_to_common_feed(attrs \\ %{}) do
    %Common{}
    |> Common.changeset(attrs)
    |> Repo.insert()
  end

  def list_common_feed() do
    # search_params = %{
    #   taken_by: "areeba",
    #   sort: :oldest
    # }

    Common
    |> limit(50)
    |> Repo.all()
    # |> order_by(:desc, :inserted_at)
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
    IO.inspect(search_params)

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

    # IO.inspect(query)

    query
  end

  def get_feed_item_by_id(id) do
    Repo.get!(Common, id)
  end

  def add_secratariat_notes(common) do
    common
    |> Repo.insert()
  end

  def add_verification_note() do
  end

  def add_tag(%Common{} = common, tag) do
  end

  def add_assessment_skeleton() do
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
  def send_assessment_report_to_user(message, target) do
  end
end
