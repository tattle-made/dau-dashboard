defmodule RabbitMQConsumerHashWorker do
  use GenServer
  use AMQP

  def start_link() do
    GenServer.start_link(__MODULE__, [], [])
  end

  @queue "count-report-queue"

  def init(_opts) do
    {:ok, chan, _queue_name} = RabbitMQ.initialize(@queue)
    {:ok, _consumer_tag} = Basic.consume(chan, @queue)

    {:ok, chan}
  end

  defp consume(_channel, _tag, _redelivered, payload) do
    IO.inspect(payload)
  end
end
