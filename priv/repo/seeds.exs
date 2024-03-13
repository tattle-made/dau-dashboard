# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     DAU.Repo.insert!(%DAU.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias DAU.Feed.Common
alias DAU.Repo

defmodule SeedFixtures do
  def pad_index(index) when index < 10, do: "0#{index}"
  def pad_index(index), do: index
end

Enum.each(0..1000, fn x ->
  file_type = Enum.shuffle(["video", "audio"]) |> hd
  file_extension = %{"video" => ".mp4", "audio" => ".wav"}[file_type]
  file_count = %{"video" => 49, "audio" => 10}[file_type]

  Repo.insert!(
    %Common{}
    |> Common.changeset(%{
      media_urls: [
        "#{file_type}-#{SeedFixtures.pad_index(:rand.uniform(file_count))}#{file_extension}"
      ],
      media_type: file_type
    })
  )
end)

# Repo.all(Common)
# |> Enum.map(fn query ->
#   Process.sleep(1000)
#   Repo.update(query, query)
# end)
