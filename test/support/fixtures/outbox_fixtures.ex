defmodule DAU.OutboxFixtures do
  alias DAU.UserMessage

  def valid_outbox_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      sender_number: "910000000000",
      sender_name: "dau_tester",
      reply_type: "customer_reply",
      type: "text",
      text: "hello from dau"
    })
  end

  def outbox_fixture(attrs \\ %{}) do
    {:ok, outbox} =
      attrs
      |> Enum.into(%{
        sender_number: "910000000000",
        sender_name: "dau_tester",
        reply_type: "customer_reply",
        type: "text",
        text: "hello from dau"
      })
      |> UserMessage.create_outbox()

    outbox
  end
end
