defmodule RabbitMQ do
  @moduledoc """
  Intialize a connection to running RabbitMQ instance and write messages to the queue that `dau-workers` will pick jobs from.
  """
  alias AMQP.{Channel, Connection, Queue, Basic}

  defstruct [:channel, :queue]
  @type success :: {:ok, String.t()}
  @type error :: {:error, reason :: String.t()}
  @type queue :: {channel :: AMQP.Channel.t(), name :: String.t()}

  def initialize_duplicate_count_queue() do
    queue_name = "count-report-queue"
    {:ok, chan, queue_name} = initialize(queue_name)

    AMQP.Queue.subscribe(chan, queue_name, fn payload, _meta ->
      IO.puts("Received from report queue: #{payload}")
    end)

    {:ok, chan, queue_name}
  end

  def add_to_duplicate_count_queue(id, file_path) do
    queue_name = "count-queue"
    {:ok, chan, queue_name} = initialize(queue_name)
    message(chan, queue_name, %{id: id, path: file_path})

    {:ok, chan, queue_name}
  end

  @doc """
  Initializes a connection between dashboard and a RabbitMQ server.

  This is imperative for jobs to be successfully scheduled.
  """
  @spec initialize(queue_name :: String.t()) :: {:ok, AMQP.Channel.t(), binary()}
  def initialize(queue) do
    rabbitmq_url = Application.get_env(:dau, RabbitMQ, :url) |> Keyword.get(:url)
    {:ok, conn} = Connection.open(rabbitmq_url)
    {:ok, chan} = Channel.open(conn)
    {:ok, %{queue: queue_name}} = Queue.declare(chan, queue, durable: true)

    {:ok, chan, queue_name}
  end

  @doc """
  Adds a message to @queue_name.
  """
  def message(chan, queue, message) do
    Basic.publish(chan, "", queue, Jason.encode!(message))
  end
end
