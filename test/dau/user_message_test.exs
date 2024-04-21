defmodule DAU.UserMessageTest do
  alias DAU.UserMessage.Outbox
  alias DAU.AccountsFixtures
  alias DAU.OutboxFixtures
  alias DAU.UserMessage
  use DAU.DataCase

  alias DAU.UserMessageFixtures
  alias DAU.FeedFixtures

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
    end

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
      _user_message = context.user_message

      # get user_message

      # IO.inspect(user_message)
      # UserMessage.add_inbox_message_to_query(user_message)
    end

    test "add inbox message to existing query", _context do
    end

    test "add user query to common feed" do
    end
  end

  describe "outbox" do
    setup do
      # create message in inbox
      # {:ok, datetime_1} = DateTime.new(~D[2024-03-25], ~T[08:30:00.000], "Etc/UTC")
      # {:ok, datetime_2} = DateTime.new(~D[2024-03-20], ~T[08:30:00.000], "Etc/UTC")
      # {:ok, datetime_3} = DateTime.new(~D[2024-03-17], ~T[08:30:00.000], "Etc/UTC")

      # user_messages = [
      #   %{inserted_at: datetime_1, updated_at: datetime_1, content_id: "UNIQUE_CONTENT_ID"},
      #   %{inserted_at: datetime_2, updated_at: datetime_2, content_id: "UNIQUE_CONTENT_ID"},
      #   %{inserted_at: datetime_3, updated_at: datetime_3, content_id: "UNIQUE_CONTENT_ID"}
      # ]

      # user_messages =
      #   user_messages
      #   |> Enum.map(&UserMessageFixtures.inbox_message_with_date_fixture(&1))

      # create query
      # create common
      {:ok, datetime_1} = DateTime.new(~D[2024-03-25], ~T[08:30:00.000], "Etc/UTC")

      common_feed_item_a =
        FeedFixtures.common_with_date(%{
          inserted_at: datetime_1,
          updated_at: datetime_1,
          user_response: "test message to be sent to user."
        })

      %{common_feed: common_feed_item_a}
    end

    test "add dau response to outbox", context do
      common = context.common_feed

      {:ok, result} = UserMessage.add_response_to_outbox(common)

      assert result.user_message_outbox.sender_number == "0000000000"
      assert result.user_message_outbox.reply_type == :notification

      # todo
      # get all entities - common, query, inbox, outbox with their associations
      # write assertions.
    end

    test "associate outbox to query" do
      {:ok, query} = UserMessage.create_query(%{status: "pending"})

      {:ok, outbox} =
        UserMessage.create_outbox(%{
          sender_number: "910000000000",
          reply_type: "customer_reply",
          type: "text",
          text: "hi"
        })

      # IO.inspect(outbox)
      {:ok, result} = UserMessage.add_outbox_to_query(query, outbox)

      assert query.id == result.id
      assert outbox.id == result.user_message_outbox_id
      assert outbox.sender_number == result.user_message_outbox.sender_number
    end

    test "approve message in outbox" do
      outbox = OutboxFixtures.outbox_fixture()

      user =
        AccountsFixtures.valid_user_attributes(%{role: :admin})
        |> AccountsFixtures.user_fixture()

      # IO.inspect(user)
      # IO.inspect(outbox)

      {:ok, result} = UserMessage.approve_message_in_outbox(outbox, user)
      # IO.inspect(result)
      assert result.approved_by == user.id
      assert result.approver.id == user.id
      assert result.id == outbox.id
      assert result.sender_number == outbox.sender_number
      # check if users with only a certain role can do this
    end

    test "permissions to approve message in outbox" do
      outbox = OutboxFixtures.outbox_fixture()

      admin =
        AccountsFixtures.valid_user_attributes(%{role: :admin})
        |> AccountsFixtures.user_fixture()

      secratariat_associate =
        AccountsFixtures.valid_user_attributes(%{role: :secratariat_associate})
        |> AccountsFixtures.user_fixture()

      secratariat_manager =
        AccountsFixtures.valid_user_attributes(%{role: :secratariat_manager})
        |> AccountsFixtures.user_fixture()

      expert_factchecker =
        AccountsFixtures.valid_user_attributes(%{role: :expert_factchecker})
        |> AccountsFixtures.user_fixture()

      expert_forensic =
        AccountsFixtures.valid_user_attributes(%{role: :expert_forensic})
        |> AccountsFixtures.user_fixture()

      user =
        AccountsFixtures.valid_user_attributes(%{role: :user})
        |> AccountsFixtures.user_fixture()

      assert Permission.has_privilege?(admin, :approve, Outbox) == true
      assert Permission.has_privilege?(secratariat_manager, :approve, Outbox) == false
      assert Permission.has_privilege?(secratariat_associate, :approve, Outbox) == false

      assert Permission.has_privilege?(expert_factchecker, :approve, Outbox) == false

      assert_raise PermissionException, fn ->
        UserMessage.approve_message_in_outbox(outbox, expert_factchecker)
      end

      assert Permission.has_privilege?(expert_forensic, :approve, Outbox) == false

      assert_raise PermissionException, fn ->
        UserMessage.approve_message_in_outbox(outbox, expert_forensic)
      end

      assert Permission.has_privilege?(user, :approve, Outbox) == false

      assert_raise PermissionException, fn ->
        UserMessage.approve_message_in_outbox(outbox, user)
      end
    end

    test "send message to user " do
    end

    test "store delivery report" do
      outbox = OutboxFixtures.outbox_fixture(%{e_id: "123213123"})

      {:ok, result} =
        UserMessage.add_delivery_report(outbox.id, %{
          "delivery_status" => "success",
          "delivery_report" => "22 successfully delivered"
        })

      assert result.id == outbox.id
      assert result.delivery_status == :success
    end
  end
end
