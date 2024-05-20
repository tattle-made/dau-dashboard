defmodule DAU.MediaMatch.RabbitMQQueue do
  alias DAU.MediaMatch.RabbitMQQueue
  defstruct [:channel, :queue_name]

  @type t :: %__MODULE__{
          channel: AMQP.Channel.t(),
          queue_name: String.t()
        }

  def new(attrs \\ %{}) do
    struct(RabbitMQQueue, attrs)
  end
end
