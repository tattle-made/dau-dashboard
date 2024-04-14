defmodule DAU.Feed.CommonTest do
  alias DAU.Feed
  alias DAU.Feed.FactcheckArticle
  alias DAU.FeedFixtures
  use DAU.DataCase
  alias DAU.Feed.Common

  describe "changeset validation" do
    test "changeset" do
      common =
        %Common{}
        |> Common.changeset(FeedFixtures.valid_attributes())

      assert common.valid? == true
    end

    test "annotation changeset" do
      common =
        %Common{}
        |> Common.changeset(FeedFixtures.valid_attributes())
        |> Common.annotation_changeset(%{
          "verification_note" => "test note",
          "tags" => ["politics", "ai generated"]
        })

      assert common.valid? == true
    end
  end
end
