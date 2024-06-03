defmodule DAU.UserMessage.AnalyticsTest do
  alias DAU.UserMessage
  alias DAU.Feed
  alias DAU.UserMessageFixtures
  alias DAU.UserMessage.Conversation
  alias DAU.UserMessage.Outbox
  alias DAU.OutboxFixtures
  use DAU.DataCase
  alias DAU.Repo

  describe "add events for bsp delivery report" do
    setup do
      conversation =
        with message <-
               UserMessageFixtures.inbox_message_attrs(:video, %{"user_language_input" => "hi"}),
             {:ok, raw_conversation} <- Conversation.add_message(message),
             {:ok, conversation} <- Conversation.build(raw_conversation.id),
             {:ok, common} <-
               Feed.get_feed_item_by_id(conversation.feed_id) |> IO.inspect(label: "commmon"),
             response <-
               Feed.add_user_response(common.id, "here goes the dau response")
               |> IO.inspect(label: "response"),
             response_2 <-
               UserMessage.add_response_to_outbox(common) |> IO.inspect(label: "response 2"),
             {:ok, conversation} <-
               Conversation.get_by_common_id(common.id) |> Conversation.build() do
          {:ok}
        end

      e_id = "5145722132009541678"
      %{id: msg_id} = outbox = OutboxFixtures.outbox_fixture(%{e_id: e_id})

      %{conversation: conversation, msg_id: msg_id}
    end

    test "add failed delivery report", %{msg_id: msg_id, conversation: conversation} do
      # Repo.get(Outbox, msg_id) |> IO.inspect()
      IO.inspect(conversation)
    end
  end
end
