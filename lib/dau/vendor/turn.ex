defmodule DAU.Vendor.Turn do
  require Logger

  def send_message_to_bsp(outbox) do
    turn_token = System.get_env("TURN_TOKEN")

    headers = [
      {"Content-Type", "application/json"},
      {"Authorization", "Bearer #{turn_token}"}
    ]

    body =
      %{
        "preview_url" => false,
        "recipient_type" => "individual",
        "to" => outbox.sender_number,
        "type" => "text",
        "text" => %{
          "body" => outbox.text
        }
      }
      |> Jason.encode!()

    endpoint = System.get_env("TURN_ENDPOINT")
    HTTPoison.post(endpoint, body, headers)
  end

  def send_template_to_bsp(outbox, template_meta) do
    # turn_token = Application.get_env(:dau, :turn_token)
    turn_token = System.get_env("TURN_TOKEN")
    turn_namespace = System.get_env("TURN_NAMESPACE")

    %{template_name: template_name, language: lang_code, params: params} =
      make_template(template_meta)

    headers = [
      {"Content-Type", "application/json"},
      {"Authorization", "Bearer #{turn_token}"}
    ]

    parameters =
      case Jason.encode(params) do
        {:ok, json} ->
          json

        {:error, reason} ->
          # Handle the error case
          IO.puts("Failed to encode: #{reason}")
          :error
      end

    body = """
        {
            "to": "#{outbox.sender_number}",
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

  def make_template(template_meta) do
    %{
      template_name: template_name,
      language: language,
      assessment_report: assessment_report,
      factcheck_articles: factcheck_articles
    } = template_meta

    params = []

    params =
      if assessment_report != nil do
        [%{type: "text", text: assessment_report} | params]
      else
        params
      end

    params =
      if factcheck_articles != [] do
        factcheck_articles
        |> Enum.reduce(params, fn article, acc ->
          domain_param = %{type: "text", text: article.domain}
          url_param = %{type: "text", text: article.url}
          [domain_param, url_param | acc]
        end)
      else
        params
      end

    params = Enum.reverse(params)

    %{
      template_name: template_name,
      language: language,
      params: params
    }
  end

  def make_delivery_report_for_outbox(params) do
    params = params["statuses"]
    params = params |> hd

    cause = ""

    # Extract the first error
    errors = List.first(params["errors"] || [%{}])

    # Update Cause if there is an error
    cause =
      if map_size(errors) > 0 do
        errors["title"]
      else
        cause
      end

    # Only code for the first error
    error_code = Map.get(errors, "code", "SUCCESS")

    # Possible known values : {sent, delivered, read, failed, success}
    event_type = Map.get(params, "status", "ERROR")

    delivery_status =
      case event_type do
        type when type in ["sent", "delivered", "read"] -> "success"
        "failed" -> "error"
        _ -> "unknown"
      end

    external_id = Map.get(params, "id", "ERROR-ERROR")

    msg_id = external_id

    delivery_report =
      if cause == "" do
        "#{error_code} : #{event_type} : #{external_id}"
      else
        "#{error_code} : #{event_type} : #{cause} : #{external_id}"
      end

    IO.inspect(delivery_report, label: "delivery_report: ")

    res = {
      msg_id,
      %{
        delivery_report: delivery_report,
        delivery_status: delivery_status
      }
    }

    IO.inspect(res, label: "Response IS: ")

    res
  end
end
