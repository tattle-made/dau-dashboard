defmodule DAU.UserMessage.AnalyticsTest do
  alias DAU.UserMessage
  alias DAU.Feed
  alias DAU.UserMessageFixtures
  alias DAU.UserMessage.Conversation
  alias DAU.UserMessage.Outbox
  alias DAU.OutboxFixtures
  use DAU.DataCase, async: true
  alias DAU.Repo

  describe "create secratariat approval event" do
    @inbox_attrs %{"user_language_input" => "hi"}
    @user_response "here goes the dau response"
    @outbox_attrs %{e_id: "5145722132009541678"}

    setup do
      with message <- UserMessageFixtures.inbox_message_attrs(:video, @inbox_attrs),
           {:ok, message_added} <- Conversation.add_message(message),
           {:ok, conversation} <- Conversation.build(message_added.id),
           common <- Feed.get_feed_item_by_id(conversation.feed_id),
           {:ok, common} <- Feed.add_user_response(common.id, @user_response),
           {:ok, _query} <- UserMessage.add_response_to_outbox(common),
           {:ok, conversation} <- Conversation.get_by_common_id(common.id),
           %{id: outbox_id} <- OutboxFixtures.outbox_fixture(@outbox_attrs) do
        %{conversation: conversation, outbox_id: outbox_id}
      end
    end

    test "add failed delivery report", %{conversation: conversation, outbox_id: outbox_id} do
      # Repo.get(Outbox, msg_id) |> IO.inspect()
      IO.inspect(conversation, label: "conversation")
      IO.inspect(outbox_id, label: "outbox id")

      # Analytics.create_secratariat_approval_event(conversation) :: %UserMessage.Analytics.Event{id}
      # assert if
    end
  end

  # describe "create delivery report" do
  #   setup do
  #   end

  #   test "delivery report for success" do
  #   end

  #   test "delivery report for failure" do
  #   end
  # end
end
