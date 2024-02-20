defmodule DAU.CanonFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `DAU.Canon` context.
  """

  @doc """
  Generate a manipulated_media.
  """
  def manipulated_media_fixture(attrs \\ %{}) do
    {:ok, manipulated_media} =
      attrs
      |> Enum.into(%{
        description: "some description",
        url: "some url"
      })
      |> DAU.Canon.create_manipulated_media()

    manipulated_media
  end

  @doc """
  Generate a factcheck_article.
  """
  def factcheck_article_fixture(attrs \\ %{}) do
    {:ok, factcheck_article} =
      attrs
      |> Enum.into(%{
        author: "some author",
        excerpt: "some excerpt",
        publisher: "some publisher",
        title: "some title",
        url: "some url"
      })
      |> DAU.Canon.create_factcheck_article()

    factcheck_article
  end
end
