defmodule DAU.Feed do
  import Ecto.Query, warn: false
  alias DAU.Repo

  alias DAU.Feed.Common

  def add_to_common_feed(attrs \\ %{}) do
    %Common{}
    |> Common.changeset(attrs)
    |> Repo.insert()
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

  def take_up() do
  end
end
