defmodule DAU.MediaMatch.HashResultWorker do
  @moduledoc """
  Runs hash result jobs that the Python hash worker inserts on the `media_results` queue.
  """
  use Oban.Worker, queue: :media_results, max_attempts: 5

  alias DAU.MediaMatch.Blake2B

  @impl Oban.Worker
  def perform(%Oban.Job{args: args}) do
    case Blake2B.worker_response_received(args) do
      # Finish job
      {:ok, :ok} -> :ok
      # Cancel job
      {:error, :invalid_args} -> {:cancel, :invalid_args}
      {:error, :inbox_not_found} -> {:cancel, :inbox_not_found}
      # Retry job
      {:error, reason} -> {:error, reason}
    end
  end
end
