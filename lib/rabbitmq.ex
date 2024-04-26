defmodule RabbitMQ do
  @moduledoc """
  Intialize a connection to running RabbitMQ instance and write messages to the queue that `dau-workers` will pick jobs from.
  """
  alias AMQP.{Channel, Connection, Queue, Basic}

  defstruct [:channel, :queue]
  @type success :: {:ok, String.t()}
  @type error :: {:error, reason :: String.t()}
  @type queue :: {channel :: AMQP.Channel.t(), name :: String.t()}

  @type t :: %__MODULE__{
          channel: AMQP.Channel.t(),
          queue: String.t()
        }

  def new(attrs \\ %{}) do
    struct(RabbitMQ, attrs)
  end

  def initialize_duplicate_count_queue() do
    queue_name = "count-report-queue"
    {:ok, %RabbitMQ{} = mq_queue} = initialize(queue_name)

    AMQP.Queue.subscribe(mq_queue.channel, mq_queue.queue, fn payload, _meta ->
      IO.puts("Received from report queue: #{payload}")
    end)

    {:ok, mq_queue}
  end

  def add_to_duplicate_count_queue(id, file_path) do
    queue_name = "count-queue"
    {:ok, %RabbitMQ{} = mq_queue} = initialize(queue_name)
    message(mq_queue.channel, mq_queue.queue, %{id: id, path: file_path})

    {:ok, mq_queue}
  end

  @doc """
  Initializes a connection between dashboard and a RabbitMQ server.

  This is imperative for jobs to be successfully scheduled.
  """
  @spec initialize(queue_name :: String.t()) :: {:ok, RabbitMQ.t()}
  def initialize(queue) do
    rabbitmq_url = Application.get_env(:dau, RabbitMQ, :url) |> Keyword.get(:url)
    {:ok, conn} = Connection.open(rabbitmq_url)
    {:ok, chan} = Channel.open(conn)
    {:ok, %{queue: queue_name}} = Queue.declare(chan, queue, durable: true)

    {:ok, RabbitMQ.new(%{channel: chan, queue: queue_name})}
  end

  @doc """
  Adds a message to @queue_name.
  """
  def message(chan, queue, message) do
    Basic.publish(chan, "", queue, Jason.encode!(message))
  end
end
