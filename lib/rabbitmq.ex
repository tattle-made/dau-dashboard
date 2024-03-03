defmodule RabbitMQ do
  @moduledoc """
  Intialize a connection to running RabbitMQ instance and write messages to the queue that `dau-workers` will pick jobs from.
  """
  alias AMQP.{Channel, Connection, Queue, Basic}

  @queue_name "tattle-search-index-queue"

  defstruct [:channel, :queue]
  @type success :: {:ok, String.t()}
  @type error :: {:error, reason :: String.t()}
  @type queue :: {channel :: AMQP.Channel.t(), name :: String.t()}

  @doc """
  Initializes a connection between dashboard and a RabbitMQ server.

  This is imperative for jobs to be successfully scheduled.
  """
  @spec initialize() :: {:ok, AMQP.Channel.t(), binary()}
  def initialize() do
    rabbitmq_url = Application.get_env(:dau, RabbitMQ, :url) |> Keyword.get(:url)
    {:ok, conn} = Connection.open(rabbitmq_url)
    {:ok, chan} = Channel.open(conn)
    {:ok, %{queue: queue_name}} = Queue.declare(chan, @queue_name)

    {:ok, chan, queue_name}
  end

  @doc """
  Adds a message to @queue_name.
  """
  def message(chan, queue, message) do
    Basic.publish(chan, "", queue, Jason.encode!(message))
  end
end
