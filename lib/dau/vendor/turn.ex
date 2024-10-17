defmodule DAU.Vendor.Turn do
  require Logger

  def send_message_to_bsp(phone_number, message) do
    turn_token = System.get_env("TURN_TOKEN")

    headers = [
      {"Content-Type", "application/json"},
      {"Authorization", "Bearer #{turn_token}"}
    ]

    body =
      %{
        "preview_url" => false,
        "recipient_type" => "individual",
        "to" => phone_number,
        "type" => "text",
        "text" => %{
          "body" => message
        }
      }
      |> Jason.encode!()

    endpoint = System.get_env("TURN_ENDPOINT")
    HTTPoison.post(endpoint, body, headers)
  end

  def send_template_to_bsp(phone_number, template_name, lang_code, params) do
    # turn_token = Application.get_env(:dau, :turn_token)
    turn_token = System.get_env("TURN_TOKEN")
    turn_namespace = System.get_env("TURN_NAMESPACE")

    headers = [
      {"Content-Type", "application/json"},
      {"Authorization", "Bearer #{turn_token}"}
    ]

    # Params Sturcture


    # """
    # params = [
    # %{type: "text", text: "Factly"},
    # %{
    #   type: "text",
    #   text:
    #     "https://factly.in/a-clipped-video-is-shared-as-visuals-of-modi-commenting-against-the-reservation-system/"
    # },
    # %{type: "text", text: "Vishvas News"},
    # %{
    #   type: "text",
    #   text:
    #     "https://www.vishvasnews.com/viral/fact-check-chhattisgarh-cm-vishnu-deo-sai-did-not-appeal-to-voters-in-favor-of-congress-candidate-bhupesh-baghel-a-viral-video-is-fake-and-altered/"
    # }
    # ]
    # """

    parameters =
      case Jason.encode(params) do
        {:ok, json} ->
          json

        {:error, reason} ->
          # Handle the error case
          IO.puts("Failed to encode: #{reason}")
          :error
      end

    # To test in IEX shell

    # test = """

    # DAU.UserMessage.MessageDelivery.Production.send_template_to_bsp("919999999999","cheapfake_wo_ar_2fc_en","en",[
    #   %{type: "text", text: "Factly"},
    #   %{
    #     type: "text",
    #     text:
    #       "https://factly.in/a-clipped-video-is-shared-as-visuals-of-modi-commenting-against-the-reservation-system/"
    #   },
    #   %{type: "text", text: "Vishvas News"},
    #   %{
    #     type: "text",
    #     text:
    #       "https://www.vishvasnews.com/viral/fact-check-chhattisgarh-cm-vishnu-deo-sai-did-not-appeal-to-voters-in-favor-of-congress-candidate-bhupesh-baghel-a-viral-video-is-fake-and-altered/"
    #   }
    # ])
    # """

    body = """
        {
            "to": "#{phone_number}",
            "type": "template",
            "template": {
                "namespace": "#{turn_namespace}",
                "name": "#{template_name}",
                "language": {
                    "code": "#{lang_code}",
                    "policy": "deterministic"
                },
                "components": [
                    {
                        "type": "body",
                        "parameters": #{parameters}
                    }
                ]
            }
        }
    """

    endpoint = System.get_env("TURN_ENDPOINT")
    HTTPoison.post(endpoint, body, headers)
  end

  def parse_status_response(response_body) do
    try do
      {:ok, decoded_data} = Jason.decode(response_body)

      res_msg_id =
        decoded_data["messages"]
        # Get the first item from the "messages" list
        |> List.first()
        # Extract the "id" from the map
        |> Map.get("id")

      {:ok, res_msg_id}
    rescue
      _err ->
        {:error, "Unable to parse bsp resposne"}
    end
  end
end
