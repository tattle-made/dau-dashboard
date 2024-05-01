defmodule Queue.RabbitMQ do
  @moduledoc """
  Intialize a connection to running RabbitMQ instance and write messages
  to the queue that `dau-workers` will pick jobs from.

  ## Examples
  {:ok, queue} = RabbitMQ.initialize("queue")
  {:ok} = RabbitMQ.message(queue, %{any_key: "any value", another_key: "another value"})
  """
  require Logger
  alias DAU.MediaMatch.RabbitMQQueue
  alias AMQP.{Channel, Connection, Queue, Basic}

  defstruct [:channel, :queue]
  @type success :: {:ok, String.t()}
  @type error :: {:error, reason :: String.t()}
  @type queue :: {channel :: AMQP.Channel.t(), name :: String.t()}

  @doc """
  Initializes a connection between dashboard and a RabbitMQ server.

  This is imperative for jobs to be successfully scheduled.
  """
  @spec initialize() ::
          {:ok, %{chan: AMQP.Channel.t(), queue: String.t()}} | {:error, reason: String.t()}
  def initialize() do
    with rabbitmq_url <- Application.get_env(:dau, RabbitMQ, :url) |> Keyword.get(:url),
         {:ok, conn} <- Connection.open(rabbitmq_url),
         {:ok, chan} <- Channel.open(conn) do
      {:ok, chan}
    else
      err -> {:error, "Unable to initialize rabbit mq connection and channel. #{inspect(err)}"}
    end
  end

  @spec initialize!() :: %{channel: AMQP.Channel.t(), queue: binary()}
  def initialize!() do
    case initialize() do
      {:ok, channel} -> channel
      {:error, reason} -> raise reason
    end
  end

  def declare_queue(chan, queue_name) do
    Queue.declare(chan, queue_name, durable: true)
  end

  @doc """
  Adds a message to queue.
  """
  @spec message(AMQP.Channel.t(), String.t(), any()) :: {:ok} | AMQP.Basic.error()
  def message(channel, queue_name, message) do
    with :ok <- Basic.publish(channel, "", queue_name, Jason.encode!(message)) do
      {:ok}
    else
      reason ->
        Logger.error("Unable to send message to Queue #{inspect(reason)}")

        {:error, reason}
    end
  end

  def consumer(%RabbitMQQueue{} = queue, pid) do
    Basic.consume(queue.channel, queue.queue_name, pid)
  end
end
