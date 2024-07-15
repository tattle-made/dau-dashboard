defmodule DAU.UserMessage.Analytics do
  require Logger
  alias DAU.UserMessage.Analytics.DAUEvent
  alias DAU.Feed.Common
  alias DAU.UserMessage.Analytics.BSPEvent
  alias DAU.UserMessage.Analytics.Repo, as: AnalyticsRepo
  alias DAU.UserMessage.Outbox
  alias DAU.Repo
  alias DAU.UserMessage.Analytics.DeliveryReport
  require IEx

  def get_all_chronologically() do
  end

  def get_all_for_feed_common(common_id) do
    with common <- Repo.get!(Common, common_id) |> Repo.preload(:query),
         events <- AnalyticsRepo.get_by_query_id(common.query.id) do
      {:ok, events}
    else
      _err -> {:error, "We were unable to load events for this conversation"}
    end
  end

  def get_all_for_feed_common!(common_id) do
    {:ok, events} = get_all_for_feed_common(common_id)
    events
  end

  def create_message_sent_event(common_id) do
    with common <- Repo.get!(Common, common_id) |> Repo.preload(:query),
         event_created <- DAUEvent.message_sent_by_secratariat!(common.query.id),
         {:ok, event_saved} <- AnalyticsRepo.save(event_created) do
      {:ok, event_saved}
    else
      _err -> {:error, "Unable to create message sent event"}
    end
  end

  def create_delivery_event(params) do
    with {:ok, report} <- DeliveryReport.build(params),
         {:ok, event_created} <- create_event(report),
         {:ok, event_saved} <- AnalyticsRepo.save(event_created) do
      {:ok, event_saved}
    else
      _err -> {:error, "Unable to create delivery event"}
    end
  rescue
    exception -> Sentry.capture_exception(exception)
  end

  defp create_event(%DeliveryReport{} = report) do
    with outbox <- Repo.get(Outbox, report.outbox_id) |> Repo.preload(:query),
         event <- BSPEvent.event(report.event_type, outbox.query.id) do
      {:ok, event}
    else
      _err -> {:error, "Unable to create event from delivery report"}
    end
  end
end
