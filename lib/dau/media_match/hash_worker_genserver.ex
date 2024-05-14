defmodule DAU.MediaMatch.HashWorkerGenServer do
  @moduledoc """
  a GenServer to that adds jobs to RabbitMQ queue for
  duplicate detection using hash worker in Feluda.

  Writes to the queue and listens for new item in the report queue.
  """
  require Logger
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
    IO.inspect(payload)

    case HashWorkerResponse.new(payload) do
      {:ok, response} ->
        # todo save in
        # inbox = UserMessage.get_incoming_message!(response.post_id) |> IO.inspect()
        # hash = MediaMatch.create_hash(response, inbox)
        # MediaMatch.increment_hash_count(hash)
        Basic.ack(chan, tag)

      {:error, reason} ->
        Logger.error(reason)

        Sentry.capture_message(
          "Reason : %s Payload : %s",
          interpolation_parameters: ["#{inspect(reason)}", "#{inspect(payload)}"]
        )

        Basic.reject(chan, tag, requeue: false)
    end

    {:noreply, chan}
  rescue
    error -> Sentry.capture_exception(error, stacktrace: __STACKTRACE__)
  end
end
