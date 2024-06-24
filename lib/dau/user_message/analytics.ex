defmodule DAU.UserMessage.Analytics do
  require Logger
  alias DAU.UserMessage.Outbox
  alias DAU.Repo
  alias DAU.UserMessage.Analytics.DeliveryReport
  alias DAU.UserMessage.Conversation
  alias DAU.UserMessage.Analytics.Event
  require IEx

  def get_all_chronologically() do
  end

  def get_all_for_feed_common(common_id) do
  end

  def create_secratariat_approval_event(params) do
    # with do
    # else
    # end
  end

  def create_delivery_event(params) do
    with {:ok, report} <- DeliveryReport.build(params),
         {:ok, event_created} <- create_event(report),
         IEx.pry(),
         {:ok, event_saved} <- Event.save(event_created) do
      {:ok, event_created}
    end
  else
    _err -> {:error, "Unable to create delivery event"}
  rescue
    exception -> Sentry.capture_exception(exception)
  end

  def create_event(%DeliveryReport{} = report) do
    with outbox <-
           Repo.get(Outbox, report.outbox_id),
         #  |> Repo.preload(:query)
         {:ok, event} <- Event.event_bsp(report, outbox.id) do
      {:ok, event}
    else
      _err ->
        {:error, "Unable to create event from delivery report"}
    end
  end

  # def create_delivery_event(params) do
  #   with {:ok, event} <- DeliveryReport.build() Event.build_from_bsp_delivery_report(params),
  #        {:ok, conversation} <- Conversation.get_by_outbox_id(event.id),
  #        {:ok, _event} <- save_event(event, conversation.feed_id) do
  #     {:ok}
  #   end
  # else
  #   err ->
  #     Logger.error(err)
  #     Sentry.capture_message("#{inspect(err)}")
  # rescue
  #   err -> Sentry.capture_exception(err)
  # end
end
