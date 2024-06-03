defmodule DAU.UserMessage.Analytics do
  require Logger
  alias DAU.UserMessage.Conversation
  alias DAU.UserMessage.Analytics.Event

  def get_all_chronologically() do
  end

  def get_all_for_feed_common(common_id) do
  end

  def create_delivery_event(params) do
    with {:ok, event} <- Event.build_from_bsp_delivery_report(params),
         {:ok, conversation} <- Conversation.get_by_outbox_id(event.id),
         {:ok, _event} <- save_event(event, conversation.feed_id) do
      {:ok}
    end
  else
    err ->
      Logger.error(err)
      Sentry.capture_message("#{inspect(err)}")
  rescue
    err -> Sentry.capture_exception(err)
  end

  def save_event(event, id) when is_atom(event) do
    Event.event(event, id) |> Event.save()
  rescue
    err -> Sentry.capture_exception(err)
  end
end
