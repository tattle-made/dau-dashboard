defmodule DAU.MediaMatch.HashWorkerGenServer do
  @moduledoc """
  a GenServer to that adds jobs to RabbitMQ queue for
  duplicate detection using hash worker in Feluda.

  Writes to the queue and listens for new item in the report queue.
  """
  alias Queue.RabbitMQ
  alias DAU.MediaMatch.RabbitMQQueue

  use GenServer

  @job_queue "count-queue"
  @response_queue "count-report-queue"

  def start_link(default) when is_nil(default) do
    GenServer.start_link(__MODULE__, nil)
  end

  def add_to_job_queue(pid, message) do
    GenServer.cast(pid, {:add_job, message})
  end

  @spec init(queue_name :: String.t()) ::
          {:ok, RabbitMQQueue.t()} | {:stop, String.t()}
  def init(_default) do
    channel = RabbitMQ.initialize!()
    RabbitMQ.declare_queue(channel, @job_queue)
    RabbitMQ.declare_queue(channel, @response_queue)

    {:ok, _} = AMQP.Basic.consume(channel, @response_queue)

    {:ok, channel}
  rescue
    err ->
      {:stop, "Unable to initialize hash worker genserver. #{inspect(err)}"}
  end

  def handle_cast({:add_job, message}, channel) do
    RabbitMQ.message(channel, @job_queue, message)

    {:noreply, channel}
  end

  # Confirmation sent by the broker after registering this process as a consumer
  def handle_info({:basic_consume_ok, %{consumer_tag: consumer_tag}}, chan) do
    IO.inspect("registered as consumer - #{inspect(consumer_tag)}")
    {:noreply, chan}
  end

  # message sent by the broker
  def handle_info({:basic_deliver, payload, %{delivery_tag: tag, redelivered: redelivered}}, chan) do
    # consume(chan, tag, redelivered, payload)
    IO.inspect("message rcvd")
    IO.inspect(payload)
    AMQP.Basic.ack(chan, tag)
    {:noreply, chan}
  end
end
