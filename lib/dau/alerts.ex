defmodule DAU.Alerts do
  @moduledoc """
  Send alerts to dau admin.

  For any incident of importance, Alerts is responsible for finding the
  appropriate users and notifying them on preffered channels.
  """

  use GenServer

  @spec init(any()) :: {:ok, %{name: <<_::40>>}}
  def init(_init_arg) do
    state = %{name: "alert"}
    {:ok, state}
  end

  def handle_call(:ping, _from, state) do
    {:reply, state, state}
  end
end
