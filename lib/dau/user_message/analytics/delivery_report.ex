defmodule DAU.UserMessage.Analytics.DeliveryReport do
  @moduledoc """
  e_id is synonymous with txn_id and msg_id (terms used in the vendor documentation and
  informal communications)
  """
  defstruct [:outbox_id, :e_id, :event_type]

  @doc """
  Build a structured delivery report from parameters sent by the bsp
  """
  def build(params) do
    try do
      params = params["_json"]
      params = params |> hd
      event_type = Map.get(params, "eventType", nil)
      external_id = Map.get(params, "externalId", "ERROR-ERROR")

      length =
        String.split(external_id, "-")
        |> hd
        |> String.length()

      length_plus_one = length + 1
      length_minus_one = length - 1

      txn_id = String.slice(external_id, 0..length_minus_one)
      msg_id = String.slice(external_id, length_plus_one..-1)

      event_type_atom = event_type_atom(event_type)
      # event = event_bsp(event_type_atom, txn_id, msg_id)

      {:ok, %__MODULE__{outbox_id: msg_id, e_id: txn_id, event_type: event_type_atom}}
    rescue
      _ -> {:error, "Badly Formatted Delivery Report from BSP"}
    end
  end

  defp event_type_atom("SUCCESS"), do: :success
  defp event_type_atom("DELIVERED"), do: :delivered
  defp event_type_atom("READ"), do: :read
  defp event_type_atom("FAILED"), do: :failed
  defp event_type_atom(nil), do: :unexpected
  defp event_type_atom(_), do: :unexpected

  def event_name(%__MODULE__{event_type: :success}), do: "success"
  def event_name(%__MODULE__{event_type: :delivered}), do: "message delivered"
  def event_name(%__MODULE__{event_type: :read}), do: "message has been read by the user"
  def event_name(%__MODULE__{event_type: :failed}), do: "message could not be delivered"
  def event_name(%__MODULE__{event_type: :unexpected}), do: "unexpected delivery report"
end
