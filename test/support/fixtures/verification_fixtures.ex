defmodule DAU.VerificationFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `DAU.Verification` context.
  """

  @doc """
  Generate a query.
  """
  def query_fixture(attrs \\ %{}) do
    {:ok, query} =
      attrs
      |> Enum.into(%{
        messages: ["option1", "option2"],
        status: "some status"
      })
      |> DAU.Verification.create_query()

    query
  end

  @doc """
  Generate a comment.
  """
  def comment_fixture(attrs \\ %{}) do
    {:ok, comment} =
      attrs
      |> Enum.into(%{
        content: %{}
      })
      |> DAU.Verification.create_comment()

    comment
  end

  @doc """
  Generate a response.
  """
  def response_fixture(attrs \\ %{}) do
    {:ok, response} =
      attrs
      |> Enum.into(%{
        content: %{}
      })
      |> DAU.Verification.create_response()

    response
  end
end
