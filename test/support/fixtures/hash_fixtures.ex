defmodule DAU.HashFixtures do
  alias DAU.MediaMatch.Hash
  alias DAU.MediaMatch.HashWorkerResponse
  alias DAU.MediaMatch
  alias DAU.UserMessage.Inbox

  def get_unique_value(), do: for(_ <- 1..25, into: "", do: <<Enum.random(~c"0123456789abcdef")>>)

  def hashworker_response(%Inbox{} = inbox) do
    {:ok, hashworker_response} =
      HashWorkerResponse.new(%{
        "inbox_id" => "#{inbox.id}",
        "value" => get_unique_value()
      })

    {:ok, %Hash{} = hash} =
      MediaMatch.create_hash(hashworker_response)

    hash
  end

  def hashworker_response(%Inbox{} = inbox, value) do
    {:ok, hashworker_response} =
      HashWorkerResponse.new(%{
        "inbox_id" => "#{inbox.id}",
        "value" => value
      })

    {:ok, %Hash{} = hash} =
      MediaMatch.create_hash(hashworker_response)

    hash
  end
end
