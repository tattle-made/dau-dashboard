defmodule DAU.UserMessage.MessageDelivery do
  def client() do
    Application.get_env(:dau, :gupshup_client)
  end
end

defmodule DAU.UserMessage.MessageDelivery.Production do
  require Logger

  def send_message_to_bsp(id, phone_num, message) do
    headers = [
      {"Content-Type", "application/x-www-form-urlencoded"}
    ]

    bsp_user_id = Application.get_env(:dau, :gupshup_userid)
    bsp_password = Application.get_env(:dau, :gupshup_password)
    gupshup_endpoint = Application.get_env(:dau, :gupshup_api_endpoint)

    send_to = "send_to=#{URI.encode_www_form(phone_num)}"
    msg_type = "msg_type=DATA_TEXT"
    user_id = "userid=#{bsp_user_id}"
    auth_scheme = "auth_scheme=plain"
    password = "password=#{URI.encode_www_form(bsp_password)}"
    method = "method=SendMessage"
    version = "v=#{URI.encode_www_form("1.1")}"
    format = "format=json"
    msg = "msg=#{URI.encode_www_form(message)}"
    msg_id = "msg_id=#{URI.encode_www_form(id)}"

    body =
      "#{send_to}&#{msg_type}&#{user_id}&#{auth_scheme}&#{password}&#{method}&#{version}&#{format}&#{msg}&#{msg_id}"

    HTTPoison.post(gupshup_endpoint, body, headers)
  end

  def send_template_to_bsp(id, phone_number, message) do
    headers = [
      {"Content-Type", "application/x-www-form-urlencoded"}
    ]

    bsp_user_id = Application.get_env(:dau, :gupshup_hsm_userid)
    bsp_password = Application.get_env(:dau, :gupshup_hsm_password)
    gupshup_api_endpoint = Application.get_env(:dau, :gupshup_api_endpoint)

    params = %{
      userid: bsp_user_id,
      password: bsp_password,
      send_to: phone_number,
      v: "1.1",
      format: "json",
      msg_type: "TEXT",
      method: "SENDMESSAGE",
      msg: message,
      msg_id: id
    }

    HTTPoison.post(gupshup_api_endpoint, "", headers, params: params)
  end

  # FOR TURN
  # def send_template_to_bsp(phone_number, template_name, lang_code, params) do
  #   # turn_token = Application.get_env(:dau, :turn_token)
  #   turn_token = System.get_env("TURN_TOKEN")
  #   turn_namespace = System.get_env("TURN_NAMESPACE")

  #   headers = [
  #     {"Content-Type", "application/json"},
  #     {"Authorization", "Bearer #{turn_token}"}
  #   ]

  #   ~c"""
  #   params = [
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
  #   ]
  #   """

  #   parameters =
  #     case Jason.encode(params) do
  #       {:ok, json} ->
  #         json

  #       {:error, reason} ->
  #         # Handle the error case
  #         IO.puts("Failed to encode: #{reason}")
  #         :error
  #     end

  #   test = """

  #   DAU.UserMessage.MessageDelivery.Production.send_template_to_bsp("919409425391","cheapfake_wo_ar_2fc_en","en",[
  #     %{type: "text", text: "Factly"},
  #     %{
  #       type: "text",
  #       text:
  #         "https://factly.in/a-clipped-video-is-shared-as-visuals-of-modi-commenting-against-the-reservation-system/"
  #     },
  #     %{type: "text", text: "Vishvas News"},
  #     %{
  #       type: "text",
  #       text:
  #         "https://www.vishvasnews.com/viral/fact-check-chhattisgarh-cm-vishnu-deo-sai-did-not-appeal-to-voters-in-favor-of-congress-candidate-bhupesh-baghel-a-viral-video-is-fake-and-altered/"
  #     }
  #   ])
  #   """

  #   body = """
  #       {
  #           "to": "#{phone_number}",
  #           "type": "template",
  #           "template": {
  #               "namespace": "#{turn_namespace}",
  #               "name": "#{template_name}",
  #               "language": {
  #                   "code": "#{lang_code}",
  #                   "policy": "deterministic"
  #               },
  #               "components": [
  #                   {
  #                       "type": "body",
  #                       "parameters": #{parameters}
  #                   }
  #               ]
  #           }
  #       }
  #   """

  #   endpoint = System.get_env("TURN_TEMPLATE_ENDPOINT")
  #   HTTPoison.post(endpoint, body, headers)
  # end
end

defmodule DAU.UserMessage.MessageDelivery.Sandbox do
  @moduledoc """
  todo: add a mock http post repsonse
  """
  def send_message_to_bsp(_id, _phone_num, _message) do
    {:ok}
  end

  # def send_template_to_bsp(_id, _phone_number, _message) do
  #   {:ok}
  # end

  def send_template_to_bsp(phone_number, template_name, lang_code, params) do
    # turn_token = Application.get_env(:dau, :turn_token)
    turn_token = System.get_env("TURN_TOKEN")
    turn_namespace = System.get_env("TURN_NAMESPACE")

    headers = [
      {"Content-Type", "application/json"},
      {"Authorization", "Bearer #{turn_token}"}
    ]

    ~c"""
    params = [
    %{type: "text", text: "Factly"},
    %{
      type: "text",
      text:
        "https://factly.in/a-clipped-video-is-shared-as-visuals-of-modi-commenting-against-the-reservation-system/"
    },
    %{type: "text", text: "Vishvas News"},
    %{
      type: "text",
      text:
        "https://www.vishvasnews.com/viral/fact-check-chhattisgarh-cm-vishnu-deo-sai-did-not-appeal-to-voters-in-favor-of-congress-candidate-bhupesh-baghel-a-viral-video-is-fake-and-altered/"
    }
    ]
    """

    parameters =
      case Jason.encode(params) do
        {:ok, json} ->
          json

        {:error, reason} ->
          # Handle the error case
          IO.puts("Failed to encode: #{reason}")
          :error
      end

    test = """

    DAU.UserMessage.MessageDelivery.Production.send_template_to_bsp("919409425391","cheapfake_wo_ar_2fc_en","en",[
      %{type: "text", text: "Factly"},
      %{
        type: "text",
        text:
          "https://factly.in/a-clipped-video-is-shared-as-visuals-of-modi-commenting-against-the-reservation-system/"
      },
      %{type: "text", text: "Vishvas News"},
      %{
        type: "text",
        text:
          "https://www.vishvasnews.com/viral/fact-check-chhattisgarh-cm-vishnu-deo-sai-did-not-appeal-to-voters-in-favor-of-congress-candidate-bhupesh-baghel-a-viral-video-is-fake-and-altered/"
      }
    ])
    """

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
end
