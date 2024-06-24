defmodule DAU.UserMessage.AnalyticsTest do
  alias DAU.UserMessage.Analytics
  alias DAU.BSP.GupshupFixture
  alias DAU.UserMessage.Analytics.Event
  alias DAU.UserMessage
  alias DAU.Feed
  alias DAU.UserMessageFixtures
  alias DAU.UserMessage.Conversation
  alias DAU.UserMessage.Outbox
  alias DAU.OutboxFixtures
  use DAU.DataCase, async: true
  alias DAU.Repo
  require IEx

  describe "delivery report events" do
    @inbox_attrs %{"user_language_input" => "hi"}
    @user_response "here goes the dau response"
    @outbox_attrs %{e_id: "5145722132009541678"}

    setup do
      message = UserMessageFixtures.inbox_message_attrs(:video, @inbox_attrs)
      {:ok, message_added} = Conversation.add_message(message)
      {:ok, common} = Feed.add_user_response(message_added.common_id, @user_response)
      {:ok, _query} = UserMessage.add_response_to_outbox(common)
      {:ok, conversation} = Conversation.get_by_common_id(common.id)
      %{id: outbox_id} = OutboxFixtures.outbox_fixture(@outbox_attrs)

      %{conversation: conversation, outbox_id: outbox_id}
    end

    test "add failed delivery report", %{conversation: conversation, outbox_id: outbox_id} do
      delivery_report_failed_params = GupshupFixture.failure_report(@outbox_attrs.e_id, outbox_id)

      event = Analytics.create_delivery_event(delivery_report_failed_params)

      IO.inspect(event)
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
