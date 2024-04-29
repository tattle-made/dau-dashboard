defmodule DAU.JobCase do
  @moduledoc """
  This module defines the setup for tests requiring access
  to the application's queue.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      alias WorkerQueue.RabbitMQ
      import DAU.JobCase
    end
  end

  # setup do
  #   {:ok, %RabbitMQ{} = mq} = RabbitMQ.initialize("test-hash-worker-job-queue")
  #   on_exit(fn -> WorkerQueue.RabbitMQ.reset() end)
  #   %{mq: mq}
  # end

  @doc """
  Setup helper that declares queues for media matching using feluda's
  hashworker.

    setup :declare_count_queues
  """
  defp declare_count_queues(_context) do
    # declare both queues
  end
end
