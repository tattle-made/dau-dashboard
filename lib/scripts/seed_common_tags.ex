defmodule Scripts.SeedCommonTags do
  alias DAU.Feed.Common
  alias DAU.OpenData
  alias DAU.OpenData.Tag
  alias DAU.OpenData.CommonTag
  alias DAU.Repo
  import Ecto.Query

  @doc """
  Seeds the common_tags join table by matching tags from the Common.tags array
  with actual tags in the tags table.

  Can be run multiple times safely - it skips existing entries based on the
  unique constraint (common_id, tag_id).
  """
  def run() do
    # Get all common entries with non-empty tags
    commons =
      Common
      |> where([c], not is_nil(c.tags))
      |> Repo.all()

    IO.puts("Processing #{length(commons)} common entries...")

    Enum.each(commons, fn common ->
      if common.tags && Enum.any?(common.tags) do
        process_common_tags(common)
      end
    end)

    IO.puts("Done seeding common_tags!")
  end

  defp process_common_tags(common) do
    Enum.each(common.tags, fn tag_name ->
      # Try to find the tag in the database
      tag = find_tag(tag_name)

      case tag do
        nil ->
          IO.puts("Tag not found: '#{tag_name}' for common_id: #{common.id}")

        %Tag{id: tag_id} ->
          # Check if the join entry already exists
          existing =
            Repo.get_by(CommonTag, common_id: common.id, tag_id: tag_id)

          case existing do
            nil ->
              # Create the join entry
              case create_common_tag(common.id, tag_id) do
                {:ok, _} ->
                  :ok

                {:error, reason} ->
                  IO.puts(
                    "Failed to create CommonTag for common_id: #{common.id}, tag_id: #{tag_id}, reason: #{inspect(reason)}"
                  )
              end

            _existing ->
              # Entry already exists, skip
              :ok
          end
      end
    end)
  end

  defp find_tag(tag_name) do
    # First try to find by exact name match
    case Repo.get_by(Tag, name: tag_name) do
      nil ->
        # Try to find by slug match
        slug = OpenData.normalize_tag(tag_name)
        Repo.get_by(Tag, slug: slug)

      tag ->
        tag
    end
  end

  defp create_common_tag(common_id, tag_id) do
    %CommonTag{}
    |> CommonTag.changeset(%{common_id: common_id, tag_id: tag_id})
    |> Repo.insert()
  end
end
