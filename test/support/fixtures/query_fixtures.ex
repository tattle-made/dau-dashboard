defmodule DAU.QueryFixtures do
  alias DAU.UserMessage

  def query(attrs \\ %{}) do
    {:ok, query} =
      attrs
      |> Enum.into(%{
        "status" => "pending"
      })
      |> UserMessage.create_query()

    query
  end
end
