defmodule DAU.UserMessageTest do
  alias DAU.Accounts.User
  use DAU.DataCase

  describe "incoming_messages" do
  end

  describe "bsp payload" do
    alias DAU.UserMessage.Payload

    test "text payload" do
      payload_string =
        ~c"{\"botname\":\"productcatloguatbot\",\"channel\":\"whatsapp\",\"contextobj\":{\"channeltype\":\"whatsapp\",\"contexttype\":\"p2p\",\"contextid\":\"whatsapp:918435249197\",\"botname\":\"productcatloguatbot\",\"senderName\":\"Nishu\",\"sourceId\":\"14156493636\"},\"senderobj\":{\"channeltype\":\"whatsapp\",\"channelid\":\"whatsapp:918435249197\",\"display\":\"Nishu\"},\"messageobj\":{\"type\":\"text\",\"text\":\"Hi\",\"from\":\"918435249197\",\"timestamp\":1661866007,\"id\":\"ABEGkYQ1JJGXAhAWNMWTV3IX9H4cTFqpvSQO\"}}"

      {:ok, payload} = Jason.decode(payload_string)
      changeset = Payload.changeset(%Payload{}, payload)
      assert changeset.valid? == true

      {:ok, _data} = Ecto.Changeset.apply_action(changeset, :insert)
      # IO.inspect(data)
    end

    test "video payload" do
      payload_string =
        ~c"{\"botname\":\"productcatloguatbot\",\"channel\":\"whatsapp\",\"contextobj\":{\"channeltype\":\"whatsapp\",\"contexttype\":\"p2p\",\"contextid\":\"whatsapp:918435249197\",\"botname\":\"productcatloguatbot\",\"senderName\":\"Nishu\",\"sourceId\":\"14156493636\"},\"senderobj\":{\"channeltype\":\"whatsapp\",\"channelid\":\"whatsapp:918435249197\",\"display\":\"Nishu\"},\"messageobj\":{\"type\":\"video\",\"text\":\"https://filemanager.gupshup.io/fm/wamedia/productcatloguatbot/9935c424-294c-4793-84d5-3096b91fcfc3\",\"url\":\"https://filemanager.gupshup.io/fm/wamedia/productcatloguatbot/9935c424-294c-4793-84d5-3096b91fcfc3\",\"from\":\"918435249197\",\"mediaId\":\"9935c424-294c-4793-84d5-3096b91fcfc3\",\"id\":\"ABEGkYQ1JJGXAhBAiWAFnVQL3lE3tNILE8Ga\"}}"

      {:ok, payload} = Jason.decode(payload_string)
      changeset = Payload.changeset(%Payload{}, payload)
      assert changeset.valid? == true
    end

    test "image payload is not supported" do
      payload_string =
        ~c"{\"botname\":\"productcatloguatbot\",\"channel\":\"whatsapp\",\"contextobj\":{\"channeltype\":\"whatsapp\",\"contexttype\":\"p2p\",\"contextid\":\"whatsapp:918435249197\",\"botname\":\"productcatloguatbot\",\"senderName\":\"Nishu\",\"sourceId\":\"14156493636\"},\"senderobj\":{\"channeltype\":\"whatsapp\",\"channelid\":\"whatsapp:918435249197\",\"display\":\"Nishu\"},\"messageobj\":{\"type\":\"image\",\"text\":\"https://filemanager.gupshup.io/fm/wamedia/productcatloguatbot/9cd22a56-3366-4ec5-8fa3-f1ca5c6dc0c4\",\"url\":\"https://filemanager.gupshup.io/fm/wamedia/productcatloguatbot/9cd22a56-3366-4ec5-8fa3-f1ca5c6dc0c4\",\"from\":\"918435249197\",\"mediaId\":\"9cd22a56-3366-4ec5-8fa3-f1ca5c6dc0c4\",\"id\":\"ABEGkYQ1JJGXAhAcocLgfCp1LCevvjdx5BMg\"}}"

      {:ok, payload} = Jason.decode(payload_string)
      changeset = Payload.changeset(%Payload{}, payload)

      # IO.inspect(changeset)
      assert changeset.valid? == false

      # assert changeset.valid? == true
      # case Ecto.Changeset.apply_action(changeset, :insert) do
      #   {:ok, data} -> IO.inspect(data)
      #   {:error, error} -> IO.inspect(error)
      # end

      {:error, _changeset} = Ecto.Changeset.apply_action(changeset, :insert)

      # {:ok, data} = Ecto.Changeset.apply_action(changeset, :insert)
      test "audio payload" do
        payload_string =
          ~c"{\"botname\":\"productcatloguatbot\",\"channel\":\"whatsapp\",\"contextobj\":{\"channeltype\":\"whatsapp\",\"contexttype\":\"p2p\",\"contextid\":\"whatsapp:918435249197\",\"botname\":\"productcatloguatbot\",\"senderName\":\"Nishu\",\"sourceId\":\"14156493636\"},\"senderobj\":{\"channeltype\":\"whatsapp\",\"channelid\":\"whatsapp:918435249197\",\"display\":\"Nishu\"},\"messageobj\":{\"type\":\"audio\",\"text\":\"https://filemanager.gupshup.io/fm/wamedia/productcatloguatbot/38b7a035-4870-401b-9064-598f05e48697\",\"url\":\"https://filemanager.gupshup.io/fm/wamedia/productcatloguatbot/38b7a035-4870-401b-9064-598f05e48697\",\"from\":\"918435249197\",\"mediaId\":\"38b7a035-4870-401b-9064-598f05e48697\",\"id\":\"ABEGkYQ1JJGXAhDUQViMZ5kSKKaDsRmi9ZFm\"}}"

        {:ok, payload} = Jason.decode(payload_string)
        changeset = Payload.changeset(%Payload{}, payload)
        assert changeset.valid? == true

        {:ok, _data} = Ecto.Changeset.apply_action(changeset, :insert)
      end
    end
  end

  describe "user message lifecycle" do
    setup do
      feed = FeedFixtures.common_feed_of_five()

      {:ok, datetime} = DateTime.new(~D[2024-03-25], ~T[08:30:00.000], "Etc/UTC")

      user_message =
        UserMessageFixtures.inbox_message_with_date_fixture(%{
          inserted_at: datetime,
          updated_at: datetime
        })

      %{common_feed: feed, user_message: user_message}
    end

    test "add inbox message to new query", context do
      user_message = context.user_message

      # get user_message

      # IO.inspect(user_message)
      # UserMessage.add_inbox_message_to_query(user_message)
    end

    test "add inbox message to existing query", context do
    end

    test "add user query to common feed" do
    end

    test "add dau response to outbox" do
    end

    test "approve message in outbox" do
    end

    test "send message to user " do
    end
  end
end
