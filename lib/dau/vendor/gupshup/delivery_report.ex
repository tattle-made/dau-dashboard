defmodule DAU.Vendor.Gupshup.DeliveryReport do
  def make_delivery_report_for_outbox(params) do
    params = params["_json"]
    params = params |> hd
    cause = Map.get(params, "cause", "ERROR")
    error_code = Map.get(params, "errorCode", "ERROR")

    # Possible known values : {SENT, DELIVERED, READ, FAILED, SUCCESS}
    event_type = Map.get(params, "eventType", "ERROR")

    delivery_status =
      case event_type do
        type when type in ["SENT", "DELIVERED", "READ", "SUCCESS"] -> "success"
        "FAILED" -> "error"
        _ -> "unknown"
      end

    external_id = Map.get(params, "externalId", "ERROR-ERROR")

    length =
      String.split(external_id, "-")
      |> hd
      |> String.length()

    length_plus_one = length + 1
    length_minus_one = length - 1

    _txn_id = String.slice(external_id, 0..length_minus_one)
    msg_id = String.slice(external_id, length_plus_one..-1)

    # [_txn_id, msg_id] = String.split(external_id, "-")

    delivery_report = "#{error_code} : #{event_type} : #{cause} : #{external_id}"

    {
      msg_id,
      %{
        delivery_report: delivery_report,
        delivery_status: delivery_status
      }
    }
  end
end
