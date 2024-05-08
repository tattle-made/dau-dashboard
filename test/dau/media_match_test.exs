defmodule DAU.MediaMatchTest do
  alias DAU.UserMessage.Query
  alias DAU.Feed
  alias DAU.UserMessage
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
      inbox_attrs = inbox_message_attrs(:video)
      {:ok, inbox_a} = UserMessage.create_incoming_message(:queue, inbox_attrs)

      {:ok, common_a} =
        Feed.add_to_common_feed("0.2.0", %{
          media_urls: [inbox_a.file_key],
          media_type: inbox_a.media_type
        })

      query_a = Query.get_with_feed_common(inbox_a.query_id)
      hash_a = hashworker_response(inbox_a)

      UserMessage.add_query_to_feed(query_a, common_a)

      inbox = MediaMatch.get_inbox_by_hash(hash_a.value, preload: true)

      assert inbox.query.id == query_a.id
      assert inbox.query.common.id == common_a.id

      # {:ok, query_a} = UserMessage.create_query(%{status: "pending"})
      # UserMessage.add_user_message_to_query(inbox_a, query_a) |> IO.inspect()
    end

    test "when this message has arrived for the first time" do
      # IO.inspect(inbox)
      # IO.inspect(hash)
    end
  end
end
