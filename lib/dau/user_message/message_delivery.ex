defmodule DAU.UserMessage.MessageDelivery do
  def send_message_to_bsp(phone_num, message) do
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

    body =
      "#{send_to}&#{msg_type}&#{user_id}&#{auth_scheme}&#{password}&#{method}&#{version}&#{format}&#{msg}"

    HTTPoison.post(gupshup_endpoint, body, headers)
  end

  def send_template_to_bsp(phone_num, template_id, params) do
    bsp_api_key = Application.get_env(:dau, :gupshup_api_key)
    bsp_endpoint = Application.get_env(:dau, :gupshup_template_api_endpoint)
    gupshup_dau_number = Application.get_env(:dau, :gupshup_dau_number)

    headers = [
      {"Content-Type", "application/x-www-form-urlencoded"},
      {"Apikey", bsp_api_key}
    ]

    source = "source=#{gupshup_dau_number}"
    destination = "destination=#{URI.encode_www_form(phone_num)}"
    template = %{id: template_id, params: params}
    template_string = Jason.encode(template) |> Tuple.to_list() |> Enum.at(1)
    template = "template=#{URI.encode_www_form(template_string)}"

    body = "#{source}&#{destination}&#{template}"

    HTTPoison.post(bsp_endpoint, body, headers)
  end
end
