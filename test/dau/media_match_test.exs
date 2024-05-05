defmodule DAU.MediaMatchTest do
  alias DAU.MediaMatch.HashWorkerResponse
  alias DAU.MediaMatch.Hash
  alias DAU.UserMessageFixtures
  alias DAU.MediaMatch
  use DAU.DataCase

  alias DAU.FeedFixtures

  describe "user response" do
    alias DAU.UserMessageFixtures

    setup do
      feed = FeedFixtures.common_feed_of_five()

      {:ok, datetime} = DateTime.new(~D[2024-03-25], ~T[08:30:00.000], "Etc/UTC")

      # create user messages (new rows in user_message_inbox)
      _message =
        UserMessageFixtures.inbox_message_with_date_fixture(%{
          inserted_at: datetime,
          updated_at: datetime
        })

      # use UserMessage context to add this message to a query
      # use UserMessage context to add this query to common_feed

      # IO.inspect(message)

      %{feed: feed}
    end

    test "add message to outbox for query within 24 hours" do
      # IO.inspect(context.feed)
      # input : feed_common_id, user_message_inbox_id
      # get user_message_inbox inserted_at

      # get an item from feed and add its response
      # for that item, find matching queries that were sent within 24 hours
      # create an entry for them in the user_message_outbox
      # assert the text in outbox and sent status
      #
    end

    test "add message to outbox for query after 24 hours" do
    end
  end

  describe "duplicates" do
    # import DAU.MediaMatchFixtures
    # alias DAU.MediaMatch

    # setup do
    #   parent = self()

    #   spawn(fn ->
    #     {:ok, %RabbitMQ{} = mq_queue} = RabbitMQ.initialize("test-hash-worker-job-queue")
    #     send(parent, {:ok, mq_queue})
    #   end)

    #   state =
    #     receive do
    #       {:ok, mq_queue} ->
    #         %{mq_queue: mq_queue}
    #     end

    #   state
    # end
    #
    test "create valid job" do
      # IO.inspect(mq_queue, label: "mq_queue")
      # inbox = inbox_video_message_fixture(%{})
      # job = MediaMatch.create_job(inbox, :hash_worker, via: :rabbitmq)

      # job_response =
    end
  end

  describe "hash" do
    setup do
      inbox = UserMessageFixtures.inbox_video_message_fixture()
      %{inbox: inbox}
    end

    test "create valid hash", %{inbox: inbox} do
      assert {:ok, %Hash{} = hash} =
               MediaMatch.create_hash(%{inbox_id: inbox.id, value: "asdfasdfdfa", version: 1})

      assert hash.inbox_id == inbox.id
    end

    test "create invalid hash" do
      assert {:error, %Ecto.Changeset{}} =
               MediaMatch.create_hash(%{inbox_id: 12, value: "asdfasdfdfa", version: 1})
    end

    test "create hash using hash worker response", %{inbox: inbox} do
      {:ok, hashworker_response} =
        HashWorkerResponse.new(%{
          "inbox_id" => "#{inbox.id}",
          "value" => "ADFSDFJSKDFJSDKFJKSDSDFSDF"
        })

      assert {:ok, %Hash{} = hash} =
               MediaMatch.create_hash(hashworker_response)

      assert hash.inbox_id == inbox.id
    end
  end

  describe "link inbox message to feed common based on hash" do
    import DAU.UserMessageFixtures
    import DAU.HashFixtures

    test "when this message has already been received" do
      inbox_a = inbox_video_message_fixture(%{sender_number: "919999999990"})
      inbox_b = inbox_video_message_fixture(%{sender_number: "919999999991"})
      # query = query_fixture(inbox)
      hash = hashworker_response(inbox_a)

      {:ok, new_hash} =
        HashWorkerResponse.new(%{inbox_id: "#{inbox_b.id}", value: hash.value})

      existing = MediaMatch.get_inbox_message_by_hash(new_hash.value) |> IO.inspect()
    end

    test "when this message has arrived for the first time" do
      # IO.inspect(inbox)
      # IO.inspect(hash)
    end
  end
end
