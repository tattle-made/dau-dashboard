defmodule DAU.MediaMatch.HashWorkerGenServer do
  @moduledoc """
  a GenServer to that adds jobs to RabbitMQ queue for
  duplicate detection using hash worker in Feluda.

  Writes to the queue and listens for new item in the report queue.
  """
  require Logger
  alias DAU.MediaMatch.Blake2B
  alias DAU.UserMessage
  alias DAU.MediaMatch
  alias DAU.MediaMatch.HashWorkerResponse
  alias Queue.RabbitMQ
  alias DAU.MediaMatch.RabbitMQQueue

  use GenServer
  use AMQP

  @job_queue "count-queue"
  @response_queue "count-report-queue"

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def add_to_job_queue(pid, message) do
    GenServer.cast(pid, {:add_job, message})
  end

  def add_to_response_queue(pid, message) do
    GenServer.cast(pid, {:add_response, message})
  end

  def status(pid) do
    GenServer.call(pid, {:status})
  end

  @spec init(queue_name :: String.t()) ::
          {:ok, RabbitMQQueue.t()} | {:stop, String.t()}
  def init(_opts) do
    channel = RabbitMQ.initialize!()
    RabbitMQ.declare_queue(channel, @job_queue)
    RabbitMQ.declare_queue(channel, @response_queue)

    Basic.consume(channel, @response_queue)
    # AMQP.Queue.subscribe(channel, @response_queue, fn payload, _meta ->
    #   IO.puts("Received: #{payload}")
    # end)

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

  def handle_cast({:add_response, message}, channel) do
    RabbitMQ.message(channel, @response_queue, message)

    {:noreply, channel}
  end

  def handle_call({:status}, _from, channel) do
    with {:ok, job_queue} <- Queue.status(channel, @job_queue),
         {:ok, response_queue} <- Queue.status(channel, @response_queue) do
      {:reply, {:ok, %{job_queue: job_queue, response_queue: response_queue}}, channel}
    else
      err -> {:reply, {:error, "Unable to get queue status. #{inspect(err)}"}, channel}
    end
  end

  # Sent by the broker when the consumer is unexpectedly cancelled (such as after a queue deletion)
  def handle_info({:basic_cancel, %{consumer_tag: consumer_tag}}, chan) do
    {:stop, :normal, chan}
  end

  # Confirmation sent by the broker to the consumer process after a Basic.cancel
  def handle_info({:basic_cancel_ok, %{consumer_tag: consumer_tag}}, chan) do
    {:noreply, chan}
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
    Logger.info("hash worker response")
    Logger.info(payload)

    case Blake2B.worker_response_received(payload) do
      :ok -> Basic.ack(chan, tag)
      {:error, _reason} -> Basic.reject(chan, tag, requeue: false)
    end

    {:noreply, chan}
  rescue
    error ->
      Logger.error(error)
      Sentry.capture_exception(error, stacktrace: __STACKTRACE__)
  end
end
