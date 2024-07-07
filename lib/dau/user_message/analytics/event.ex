defmodule DAU.UserMessage.Analytics.Event do
  defstruct [:name, :query_id]

  def new() do
    %__MODULE__{}
  end

  def set_name(%__MODULE__{} = event, name) do
    %{event | name: name}
  end

  def set_query_id(%__MODULE__{} = event, query_id) do
    %{event | query_id: query_id}
  end
end
