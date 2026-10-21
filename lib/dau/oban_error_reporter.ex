defmodule DAU.ObanErrorReporter do
  def attach do
    :telemetry.attach(
      "dau-oban-error-reporter",
      [:oban, :job, :exception],
      &__MODULE__.handle_event/4,
      nil
    )
  end

  def handle_event([:oban, :job, :exception], _measurements, metadata, _config) do
    exception = Exception.normalize(metadata.kind, metadata.reason, metadata.stacktrace)
    extra = Map.take(metadata.job, [:id, :args, :queue, :worker, :attempt, :max_attempts])

    Sentry.capture_exception(exception, stacktrace: metadata.stacktrace, extra: extra)
  end
end
