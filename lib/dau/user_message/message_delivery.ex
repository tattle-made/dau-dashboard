defmodule DAU.UserMessage.MessageDelivery do
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
end
