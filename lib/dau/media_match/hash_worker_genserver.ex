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

  def start_link() do
    GenServer.start_link(__MODULE__, [], [])
  end

  def add_to_job_queue(pid, message) do
    GenServer.cast(pid, {:add_job, message})
  end

  @spec init(queue_name :: String.t()) ::
          {:ok, RabbitMQQueue.t()} | {:stop, String.t()}
  def init(_opts) do
    channel = RabbitMQ.initialize!()
    RabbitMQ.declare_queue(channel, @job_queue)
    RabbitMQ.declare_queue(channel, @response_queue)

    AMQP.Basic.consume(channel, @response_queue)

    # AMQP.Queue.subscribe(channel, @response_queue, fn payload, _meta ->
    #   IO.inspect(payload, label: "received")
    # end)

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
    IO.inspect("registered as consumer - #{consumer_tag}}")
    {:noreply, chan}
  end

  # message sent by the broker
  def handle_info(
        {:basic_deliver, payload, %{delivery_tag: tag, redelivered: _redelivered}},
        chan
      ) do
    # consume(chan, tag, redelivered, payload)
    IO.puts("message rcvd")
    IO.puts("#{inspect(payload)}")
    AMQP.Basic.ack(chan, tag)
    {:noreply, chan}
  end
end
